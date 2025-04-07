# frozen_string_literal: true

class AccommodationsController < ApplicationController
  include Pagy::Backend

  before_action :set_accommodation, only: [:show, :edit, :update, :destroy, :like, :dislike]

  skip_before_action :authenticate_user!, only: [:index, :show, :card]

  def index
    @accommodations = params[:query].then do |query|
      query.present? ? Accommodation.search_by_title_and_description(query) : Accommodation.all
    end

    if params[:sw_lat] && params[:ne_lat] && params[:sw_lng] && params[:ne_lng]
      @accommodations = @accommodations.where(lat: params[:sw_lat]..params[:ne_lat],
                                              long: params[:sw_lng]..params[:ne_lng])
    end

    @markers = @accommodations.map do |accommodation|
      {
        lat: accommodation.lat.to_f,
        lng: accommodation.long.to_f,
        id: accommodation.id,
        markerhtml: render_to_string(partial: "accommodations/marker", locals: { accommodation: accommodation })
      }
    end

    @pagy, @accommodations = pagy(@accommodations, items: 15, turbo_frame: "accommodations_list")
  end

  def show
    @notations = Notation.where(accommodation: @accommodation)
    @user_favorite = UserFavorite.find_by(user: current_user, accommodation: @accommodation)
    @reservations = Reservation.where(accommodation: @accommodation, occupant: current_user)
    @user_notation = Notation.find_by(user: current_user, accommodation: @accommodation)
    @notation = Notation.new
    @reservation = Reservation.find_by(accommodation: @accommodation, occupant: current_user)
  end

  def new
    @accommodation = Accommodation.new
  end

  def edit
  end

  def create
    @accommodation = Accommodation.new(accommodation_params)
    @accommodation.owner = current_user

    begin
      if @accommodation.save
        redirect_to @accommodation
      else
        render :new, status: :unprocessable_entity
      end
    rescue StandardError => e
      flash[:error] = "An error occurred: #{e.message}"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @accommodation.update(accommodation_params)
      redirect_to @accommodation
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @accommodation.destroy
    redirect_to accommodations_path
  end

  def card
    @accommodation = Accommodation.find(params[:id])
    render partial: "accommodations/card", locals: { accommodation: @accommodation }
  end

  def like
    @user_favorite = UserFavorite.new(user: current_user, accommodation: @accommodation)
    @user_favorite.save

    respond_to do |format|
      format.turbo_stream do
        @user_favorite = UserFavorite.find_by(user: current_user, accommodation: @accommodation)
        if params[:view_type] == "show"
          render turbo_stream: turbo_stream.replace("favorite_button", partial: "accommodations/favorite_button",
                                                                       locals: { user_favorite: @user_favorite, accommodation: @accommodation, view_type: "show" })
        else
          render turbo_stream: turbo_stream.replace("favorite_heart_button_#{@accommodation.id}",
                                                    partial: "user_favorites/button", locals: { user_favorite: @user_favorite, accommodation: @accommodation, view_type: "index" })
        end
      end
    end
  end

  def dislike
    @accommodation = Accommodation.find(params[:id])
    @user_favorite = current_user.user_favorites.find_by(accommodation: @accommodation)

    favorite_id = @user_favorite&.id
    return unless @user_favorite&.destroy

    respond_to do |format|
      format.turbo_stream do
        @user_favorite = nil
        if params[:view_type] == "show"
          render turbo_stream: turbo_stream.replace("favorite_button",
                                                    partial: "accommodations/favorite_button",
                                                    locals: { user_favorite: @user_favorite,
                                                              accommodation: @accommodation, view_type: "show" })
        elsif params[:view_type] == "profile"
          streams = [turbo_stream.remove("favorite_#{favorite_id}")]

          if current_user.user_favorites.empty?
            streams << turbo_stream.update("favorites-container",
                                           partial: "profiles/favorites",
                                           locals: { my_favorites: [] })
          end

          render turbo_stream: streams
        else
          render turbo_stream: turbo_stream.replace("favorite_heart_button_#{@accommodation.id}",
                                                    partial: "user_favorites/button",
                                                    locals: { user_favorite: @user_favorite,
                                                              accommodation: @accommodation, view_type: "index" })
        end
      end
    end
  end

  private

  def set_accommodation
    @accommodation = Accommodation.find(params[:id])
  end

  def accommodation_params
    params.require(:accommodation).permit(:title, :description, :price, :address, :lat, :long, :category, images: [])
  end
end
