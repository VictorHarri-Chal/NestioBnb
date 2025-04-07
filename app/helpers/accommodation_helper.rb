# frozen_string_literal: true

module AccommodationHelper
  include Pagy::Frontend

  def accommodation_city(accommodation)
    Geocoder.search(accommodation.address).first.city
  end

  def accommodation_country(accommodation)
    Geocoder.search(accommodation.address).first.country
  end

  def show_favorite_button?(accommodation)
    return false unless current_user
    return false if accommodation.owner == current_user
    return false if controller_name == "profiles"

    controller_name == "accommodations"
  end
end
