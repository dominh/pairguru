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
  attr_accessor :movie_details
  delegate(*MovieDetails::ATTRS, to: :movie_details)

  def movie_details?
    movie_details.present?
  end
end
