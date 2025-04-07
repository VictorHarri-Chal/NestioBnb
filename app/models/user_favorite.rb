# frozen_string_literal: true

class UserFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :accommodation
end
