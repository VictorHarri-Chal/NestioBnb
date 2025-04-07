# frozen_string_literal: true

# Base controller for the application that all other controllers inherit from.
# Provides common functionality and configurations for all controllers.
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  protected

  def after_sign_in_path_for(resource)
    accommodations_path
  end
end
