require 'rails_helper'

describe Genre, type: :model do
  subject(:genre) { described_class.find(1) }
  before { create_list(:genre, 5, :with_movies) }

  its(:number_of_movies) { is_expected.to equal(5) }

  describe 'if new movie appear' do
    before { create :movie, genre: genre }

    its(:number_of_movies) { is_expected.to equal(6) }
  end
end
