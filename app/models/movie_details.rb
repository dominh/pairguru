class MovieDetails
  ATTRS = %I(poster average_rating plot_overview).freeze
  attr_accessor(*ATTRS)
end
