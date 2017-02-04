# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Genre < ActiveRecord::Base
  has_many :movies

  def number_of_movies
    movies.count
  end
end
