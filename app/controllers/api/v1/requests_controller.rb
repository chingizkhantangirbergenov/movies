class Api::V1::RequestsController < ApplicationController

	before_action :find_city, except: :cities

  def cities
  	cities = City.all
  	render json: cities, only: [:name, :id]
  end

  def cinemas
  	render json: @city.cinemas, only: [:id, :name]
  end

  def movies
  	render json: @city.movies, methods: :cinema_ids
  end

  def sessions
  	render json: @city.sessions
  end

  def movie_sessions
  	sessions = @city.sessions.where(movie_id: params[:movie_id])
  	render json: sessions
  end

  private
  def find_city
  	@city = City.find(params[:id])
  end
end
