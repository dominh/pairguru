require 'rails_helper'

describe Movie do
  [
    { poster: 'test.jpg', average_rating: 1.2, plot_overview: 'Lorem ipsum' },
    { poster: 'test2.jpg', average_rating: 4.2, plot_overview: 'dolor sit amet' }
  ].each_with_index do |movie_details, i|
    describe "for exact movie details #{i}" do
      subject { build(:movie) }
      before do
        TheMovieDb.any_instance.stub(:get_details_for_movie) do
          build(:movie_details, movie_details)
        end
      end
      %I(poster average_rating plot_overview).each do |attribute|
        it do
          expect(subject.send(attribute))
            .to equal(movie_details[attribute])
        end
      end
    end
  end
end
