# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :set_accommodation, only: [:new, :create]

  def new
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today + 7
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today + 14
    @voyageurs = params[:voyageurs] || 1
    @price_per_night = @accommodation.price
    @subtotal = @price_per_night * (@end_date - @start_date) * @voyageurs
    @service_fee = rand(10..20)
    @taxes = rand(1..50)
    @total_price = @subtotal + @service_fee + @taxes
    @nights = (@end_date - @start_date).to_i
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.accommodation = @accommodation
    @reservation.occupant_id = current_user.id
    if @reservation.save
      redirect_to profile_path(current_user.id, tab: "reservations")
    else
      render :new
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to profile_path(current_user.id, tab: "reservations")
  end

  def accept
    @reservation = Reservation.find(params[:id])
    @reservation.update(status: :confirmed)
    redirect_to profile_path(current_user.id, tab: "requests")
  end

  def reject
    @reservation = Reservation.find(params[:id])
    @reservation.update(status: :refused)
    redirect_to profile_path(current_user.id, tab: "requests")
  end

  private

  def set_accommodation
    @accommodation = Accommodation.find(params[:accommodation_id])
  end

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date)
  end
end
