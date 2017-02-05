class MovieDecorator < Draper::Decorator
  POSTER_SIZE = 'w300'.freeze
  delegate_all

  def cover
    'http://lorempixel.com/100/150/' + %W(abstract nightlife transport).sample + '?a=' + SecureRandom.uuid
  end

  def poster_img
    url = TheMovieDb.instance.image_base_url + POSTER_SIZE + object.poster
    h.image_tag(url, class: :'img-responsive', alt: nil)
  end
end
