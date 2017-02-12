require 'rails_helper'

RSpec.shared_examples 'json' do |schema_name|
  it 'returns json response' do
    expect(response.header['Content-Type']).to include 'application/json'
  end

  it { expect(response).to match_response_schema(schema_name) }
end

RSpec.describe MoviesController, type: :controller do
  before { sign_in }
  let!(:movies) { create_list(:movie, 2) }

  it 'renders the index template' do
    get :index
    expect(response).to render_template('index')
  end

  describe 'show' do
    describe 'decorated_movie' do
      subject { controller.decorated_movie }
      let(:movie) { movies.first }
      let(:movie_details) do
        build(
          :movie_details,
          poster: '/test_poster.jpg',
          average_rating: 1.2,
          plot_overview: 'Lorem ipsum'
        )
      end
      before do
        the_movie_db = instance_double(TheMovieDb)
        allow(the_movie_db).to receive(:get_details_for_movie).and_return(movie_details)
        allow(the_movie_db).to receive(:image_base_url).and_return('http://example.org/')
        allow(controller).to receive(:the_movie_db).and_return(the_movie_db)

        get :show, id: movie
      end

      it { is_expected.to respond_to(:cover) }

      its(:poster_img) do
        is_expected
          .to eq('<img class="img-responsive" src="http://example.org/w300/test_poster.jpg" />')
      end

      its(:average_rating) { is_expected.to eq(1.2) }
      its(:plot_overview) { is_expected.to eq('Lorem ipsum') }
    end

    describe 'decorated_movie when movie details could not be found' do
      subject { controller.decorated_movie }
      let(:movie) { movies.first }
      before do
        the_movie_db = instance_double(TheMovieDb)
        allow(the_movie_db)
          .to receive(:get_details_for_movie).and_raise(TheMovieDb::NoResults, :movie)
        allow(controller).to receive(:the_movie_db).and_return(the_movie_db)

        get :show, id: movie
      end

      its(:poster_img) do
        is_expected
          .to include('alt="Could not get image location"')
      end
      its(:average_rating) { is_expected.to eq('N/A') }
      its(:plot_overview) { is_expected.to eq('Plot overview is currently unavailable.') }
    end
  end

  describe 'send_info' do
    let(:movie) { movies.first }
    before do
      request.env['HTTP_REFERER'] = movie_path(movie)
    end

    it do
      get :send_info, id: movie
      is_expected.to redirect_to(movie_path(movie))
    end

    it 'adds new delayed job' do
      expect do
        get :send_info, id: movie
      end.to change(Delayed::Job, :count).by(1)
    end
  end

  describe 'export' do
    it do
      get :export
      is_expected.to redirect_to(root_path)
    end

    it 'adds new delayed job' do
      expect do
        get :export
      end.to change(Delayed::Job, :count).by(1)
    end
  end

  describe 'api' do
    let(:movie) { movies.first }
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
