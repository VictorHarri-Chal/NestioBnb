# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    @user = current_user
    @my_accommodations = Accommodation.where(owner_id: @user.id)
    @my_reservations = Reservation.where(occupant_id: @user.id)
    @my_favorites = UserFavorite.where(user_id: @user.id)
    @received_requests = Reservation.joins(:accommodation).where(accommodations: { owner_id: current_user.id })
  end
end
