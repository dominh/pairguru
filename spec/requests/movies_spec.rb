require 'rails_helper'

describe 'Movies requests', type: :request do
  before do
    create_list(:movie, 2)
    SecureRandom.stub(uuid: 'some_uuid')
    allow_any_instance_of(MovieDecorator)
      .to receive(:cover_image_type).and_return('abstract')
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

    it 'poster image have source url' do
      poster = find(:css, 'img.img-responsive')
      expect(poster['src']).to eq('http://example.org/w300/vdENJAPObttowMtIwe9jgtbsEnq.jpg')
    end

    it 'poster image have no alt' do
      expect(page).to have_selector('img.img-responsive:not([alt])')
    end
  end
end
