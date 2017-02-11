class MovieDecorator < Draper::Decorator
  POSTER_SIZE = 'w300'.freeze
  delegate_all

  def cover
    protocol_and_domain = 'http://lorempixel.com'
    path = "/100/150/#{cover_image_type}"
    params = "a=#{SecureRandom.uuid}"
    "#{protocol_and_domain}#{path}?#{params}"
  end

  def poster_img
    url = TheMovieDb.instance.image_base_url + POSTER_SIZE + object.poster
    h.image_tag(url, class: :'img-responsive', alt: nil)
  end

  private

  def cover_image_type
    %w(abstract nightlife transport).sample
  end
end
