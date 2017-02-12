require 'rails_helper'

describe 'Movies requests', type: :request do
  let(:movie_details) do
    build(
      :movie_details,
      poster: '/test_poster.jpg',
      average_rating: 1.2,
      plot_overview: 'Lorem ipsum'
    )
  end

  before do
    create_list(:movie, 2)
    allow(SecureRandom).to receive(:uuid).and_return('some_uuid')
    allow_any_instance_of(MovieDecorator).to receive(:cover_image_type).and_return('abstract')
    allow_any_instance_of(TheMovieDb).to receive(:get_details_for_movie).and_return(movie_details)
    allow_any_instance_of(TheMovieDb).to receive(:image_base_url).and_return('http://example.org/')
  end

  describe 'movies list' do
    before { visit '/movies' }
    it 'displays right title' do
      expect(page).to have_selector('h1', exact: 'Movies')
    end

    it 'displays movies\' posters' do
      cover = first(:css, 'img.img-rounded')
      expect(cover['src']).to eq('http://lorempixel.com/100/150/abstract?a=some_uuid')
    end
  end

  describe 'movie_page' do
    before { visit '/movies/1' }

    it 'displays poster image' do
      expect(page).to have_selector('img.img-responsive')
    end

    it 'poster image has source url' do
      poster = find(:css, 'img.img-responsive')
      expect(poster['src']).to eq('http://example.org/w300/test_poster.jpg')
    end

    it 'poster image has no alt' do
      expect(page).to have_selector('img.img-responsive:not([alt])')
    end
  end
end
