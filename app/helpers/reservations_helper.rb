# frozen_string_literal: true

module ReservationsHelper
  def reservation_status_classes(status)
    {
      "confirmed" => "bg-green-100 text-green-800",
      "pending" => "bg-yellow-100 text-yellow-800",
      "refused" => "bg-red-100 text-red-800"
    }[status.to_s] || "bg-gray-100 text-gray-800"
  end
end
