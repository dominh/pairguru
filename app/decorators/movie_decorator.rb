class MovieDecorator < Draper::Decorator
  POSTER_SIZE = 'w300'.freeze
  NO_IMAGE_URL_MESSAGE = 'Could not get image location'.freeze
  NO_PLOT_OVERVIEW_MESSAGE = 'Plot overview is currently unavailable.'.freeze
  delegate_all

  def cover
    protocol_and_domain = 'http://lorempixel.com'
    path = "/100/150/#{cover_image_type}"
    params = "a=#{SecureRandom.uuid}"
    "#{protocol_and_domain}#{path}?#{params}"
  end

  def poster_img
    if object.movie_details?
      url = h.poster_img_base_url + POSTER_SIZE + object.poster
      h.image_tag(url, class: :'img-responsive', alt: nil)
    else
      h.image_tag('no_poster.png', class: :'img-responsive', alt: NO_IMAGE_URL_MESSAGE)
    end
  end

  def average_rating
    if object.movie_details?
      object.average_rating
    else
      'N/A'
    end
  end

  def plot_overview
    if object.movie_details?
      object.plot_overview
    else
      NO_PLOT_OVERVIEW_MESSAGE
    end
  end

  private

  def cover_image_type
    %w(abstract nightlife transport).sample
  end
end
