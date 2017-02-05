require 'rails_helper'

describe 'Movies requests', type: :request do
  describe 'movies list' do
    it 'displays right title' do
      visit '/movies'
      expect(page).to have_selector('h1', exact: 'Movies')
    end
  end

  describe 'movie_page' do
    let!(:movies) { create_list(:movie, 2) }
    before { visit '/movies/1' }

    it 'displays poster image' do
      expect(page).to have_selector('img.img-responsive')
    end

    it 'poster image have source url' do
      poster = find(:css, 'img.img-responsive')
      expect(poster['src']).to eq('http://example.org/w300/vdENJAPObttowMtIwe9jgtbsEnq.jpg')
    end

    it 'poster image have no alt' do
      expect(page).to have_selector('img.img-responsive:not([alt])')
    end
  end
end
