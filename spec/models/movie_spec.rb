require 'rails_helper'
MOVIE_DETAILS_ATTRS = %I(poster average_rating plot_overview).freeze
describe Movie, type: :model do
  subject(:movie) { build(:movie) }

  describe 'when no movie_details set' do
    MOVIE_DETAILS_ATTRS.each do |attribute|
      it { expect { movie.send(attribute) }.to raise_error(Module::DelegationError) }
    end
    its(:movie_details?) { is_expected.to be false }
  end

  describe 'when movie_details set' do
    before { movie.movie_details = build(:movie_details) }

    its(:movie_details?) { is_expected.to be true }
  end

  [
    { poster: 'test.jpg', average_rating: 1.2, plot_overview: 'Lorem ipsum' },
    { poster: 'test2.jpg', average_rating: 4.2, plot_overview: 'dolor sit amet' }
  ].to_enum.with_index(1).each do |movie_details_attributes, i|
    describe "for #{i.ordinalize} movie details" do
      before do
        movie.movie_details = build(:movie_details, movie_details_attributes)
      end
      MOVIE_DETAILS_ATTRS.each do |attribute|
        its(attribute) { is_expected.to equal(movie_details_attributes[attribute]) }
      end
    end
  end
end
