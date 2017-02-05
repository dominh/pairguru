# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  released_at :datetime
#  avatar      :string
#  genre_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Movie < ActiveRecord::Base
  belongs_to :genre
  delegate *%I(poster average_rating plot_overview), to: :movie_details

  private

  def movie_details
    @movie_details ||= TheMovieDb.instance.get_details_for_movie(self)
  end
end
