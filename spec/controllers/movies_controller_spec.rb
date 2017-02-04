require 'rails_helper'
require 'benchmark'

RSpec.describe MoviesController, type: :controller do
  before do
    user = FactoryGirl.create(:user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  let!(:movies) { create_list(:movie, 2) }

  it 'renders the index template' do
    get :index
    expect(response).to render_template('index')
  end

  describe 'send_info' do
    let(:movie) { movies[1] }
    before do
      request.env['HTTP_REFERER'] = movie_path(movie)
    end

    it do
      get :send_info, id: movie
      expect(subject).to redirect_to(movie_path(movie))
    end

    it 'should add new delayed job' do
      expect do
        get :send_info, id: movie
      end.to change(Delayed::Job, :count).by(1)
    end
  end

  describe 'export' do
    let(:movie) { movies[1] }

    it do
      get :export, id: movie
      expect(subject).to redirect_to(root_path)
    end

    it 'should add new delayed job' do
      expect do
        get :export, id: movie
      end.to change(Delayed::Job, :count).by(1)
    end
  end
end
