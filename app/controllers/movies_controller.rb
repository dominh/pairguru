class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  expose_decorated(:movies) { Movie.all }
  expose_decorated(:movie)

  %I(index show).each do |action|
    define_method(action) do
      respond_to do |format|
        format.html
        format.json do
          render_json(send({ index: :movies, show: :movie }[action]))
        end
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

  private

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
