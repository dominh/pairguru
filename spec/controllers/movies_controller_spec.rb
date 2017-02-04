require 'rails_helper'
require 'benchmark'

RSpec.shared_examples 'json' do |schema_name|
  it 'should return json response' do
    response.header['Content-Type'].should include 'application/json'
  end

  it { expect(response).to match_response_schema(schema_name) }
end

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
    it do
      get :export
      expect(subject).to redirect_to(root_path)
    end

    it 'should add new delayed job' do
      expect do
        get :export
      end.to change(Delayed::Job, :count).by(1)
    end
  end

  describe 'api' do
    let(:movie) { movies[1] }
    describe 'movies collection without genre' do
      before { get :index, format: :json }
      it_should_behave_like 'json', 'movies_without_genre'
    end

    describe 'movies collection with genre' do
      before { get :index, format: :json, add_genre: 'true' }
      it_should_behave_like 'json', 'movies_with_genre'
    end

    describe 'movie without genre' do
      before { get :show, format: :json, id: movie }
      it_should_behave_like 'json', 'movie_without_genre'
    end

    describe 'movie with genre' do
      before { get :show, format: :json, add_genre: 'true', id: movie }
      it_should_behave_like 'json', 'movie_with_genre'
    end
  end
end
