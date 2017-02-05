require 'rails_helper'

describe Genre do
  let!(:genres) { create_list(:genre, 5, :with_movies) }
  subject { described_class.find(1) }

  it { expect(subject.number_of_movies).to equal(5) }
  
  describe 'if new movie appear' do
    before { create :movie, genre: subject }

    it { expect(subject.number_of_movies).to equal(6) }
  end
end
