# frozen_string_literal: true

class Reservation < ApplicationRecord
  extend Enumerize

  STATUSES = %i[pending confirmed refused].freeze
  belongs_to :accommodation, class_name: "Accommodation"
  belongs_to :occupant, class_name: "User"

  enumerize :status, in: STATUSES, predicates: true, scope: true, default: :pending
end
