# frozen_string_literal: true

class Notation < ApplicationRecord
  belongs_to :user
  belongs_to :accommodation
end
