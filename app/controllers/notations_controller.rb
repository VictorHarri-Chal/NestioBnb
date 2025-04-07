# frozen_string_literal: true

class NotationsController < ApplicationController
  before_action :set_accommodation, only: [:new, :create]

  def new
    @notation = Notation.new
  end

  def create
    @notation = Notation.new(notation_params)
    @notation.user = current_user
    @notation.accommodation = @accommodation

    if @notation.save
      redirect_to accommodation_path(@accommodation), notice: "Rating was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_accommodation
    @accommodation = Accommodation.find(params[:accommodation_id])
  end

  def notation_params
    params.require(:notation).permit(:note, :title, :description)
  end
end
