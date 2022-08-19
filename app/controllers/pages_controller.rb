require 'flickr'

class PagesController < ApplicationController
  def home
    flash.clear
    begin
      find_user_photos
    rescue => exception
      flash[:notice] = exception
      flash.now[:notice]
      render :home, status: :unprocessable_entity
    end
  end

  private

  def find_user_photos
    if params.key? :id
      flickr = Flickr.new ENV['flickr_key'], ENV['flickr_secret']
      photos = flickr.people.getPhotos user_id: params[:id], per_page: 10
      @photo_urls = []
      photos.each do |photo|
        @photo_urls << "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_w.jpg"
      end
    end
  end
end
