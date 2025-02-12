class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]
  # before_action :movie_params, only: [:create]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  def create
    movie = Movie.new(movie_params)
    
    movie.save!
    @movie = Movie.find_by(title: movie_params[:title])
    render(
      status: :ok,
      json: @movie.as_json(only: [:title, :image_url, :overview, :release_date, :id, :inventory])
    )
  end

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :overview, :release_date, :image_url, :external_id)
  end
end
