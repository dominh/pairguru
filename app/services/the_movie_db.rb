class TheMovieDb
  def get_details_for_movie(movie)
    year_of_release = movie.released_at.year
    title = movie.title
    search = Tmdb::Search.movie(title, year: year_of_release)
    raise(NoResults, movie) if search[:total_results].zero?
    result = search[:results].first
    build_movie_details(result)
  end

  def image_base_url
    config[:images][:base_url]
  end

  private

  def config
    @config ||= Tmdb::Configuration.get
  end

  def build_movie_details(result)
    MovieDetails.new.tap do |md|
      {
        poster: :poster_path,
        average_rating: :vote_average,
        plot_overview: :overview
      }.each do |model_attribute, api_attribute|
        md.send("#{model_attribute}=", result[api_attribute])
      end
    end
  end
end

class TheMovieDb
  class NoResults < StandardError
    def initialize(movie)
      @movie = movie
      super
    end

    def to_s
      'No results has been found for movie' + @movie.to_s
    end
  end
end
