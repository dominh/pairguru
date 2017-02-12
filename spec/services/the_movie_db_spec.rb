require 'rails_helper'

describe TheMovieDb do
  subject(:the_movie_db) { described_class.new }
  before do
    allow(Tmdb::Configuration)
      .to receive(:get)
      .and_return(images: { base_url: 'http://img-service.org' })
  end

  its(:image_base_url) { is_expected.to eq('http://img-service.org') }

  describe 'movie returns by get_details_for_movie' do
    before do
      allow(Tmdb::Search)
        .to receive(:movie).with(kind_of(String), any_args)
        .and_return(
          total_results: 2,
          results: [
            {
              poster_path: '/test_poster.jpg',
              vote_average: 1.1,
              overview: 'Lorem ipsum dolor sit amet'
            },
            {
              poster_path: '/test_poster2.jpg',
              vote_average: 2.2,
              overview: 'consectetur adipiscing elit'
            }
          ]
        )
    end

    subject { the_movie_db.get_details_for_movie(build(:movie)) }

    its(:poster) { is_expected.to eq('/test_poster.jpg') }
    its(:average_rating) { is_expected.to eq(1.1) }
    its(:plot_overview) { is_expected.to eq('Lorem ipsum dolor sit amet') }
  end

  describe 'movie has not been found' do
    before do
      allow(Tmdb::Search)
        .to receive(:movie).with(kind_of(String), any_args)
        .and_return(
          total_results: 0,
          results: []
        )
    end

    it do
      expect do
        the_movie_db.get_details_for_movie(build(:movie))
      end.to raise_error(TheMovieDb::NoResults)
        .with_message(/^No results has been found for movie#<Movie:/)
    end
  end
end
