# frozen_string_literal: true

# Base model class for the application that all other models inherit from.
# Provides common database functionality and configurations.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
