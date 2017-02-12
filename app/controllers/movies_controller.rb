class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  expose_decorated(:movies) { Movie.all }
  expose_decorated(:movie)

  def index
    respond_to do |format|
      format.html
      format.json do
        render_json(movies)
      end
    end
  end

  def show
    respond_to do |format|
      format.html do
        set_movie_details
      end
      format.json do
        render_json(movie)
      end
    end
  end

  def send_info
    MovieInfoMailer.delay.send_info(current_user, movie)
    redirect_to :back, notice: 'Email sent with movie info'
  end

  def export
    file_path = 'tmp/movies.csv'
    MovieExporter.new.delay.call(current_user, file_path)
    redirect_to root_path, notice: 'Movies exported'
  end

  def poster_img_base_url
    the_movie_db.image_base_url
  end
  helper_method :poster_img_base_url

  private

  def set_movie_details
    movie.movie_details =
      begin
        the_movie_db.get_details_for_movie(movie)
      rescue TheMovieDb::NoResults, Tmdb::Error
        nil
      end
  end

  def the_movie_db
    @the_movie_db ||= TheMovieDb.new
  end

  def render_json(object)
    render json: object.to_json(json_fields)
  end

  def json_fields
    movie_fields = { only: [:id, :title] }
    genre_fields = { only: [:id, :name], methods: :number_of_movies }
    if params[:add_genre] == 'true'
      movie_fields.merge(include: [genre: genre_fields])
    else
      movie_fields
    end
  end
end
