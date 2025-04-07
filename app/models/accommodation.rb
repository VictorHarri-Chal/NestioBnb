# frozen_string_literal: true

class Accommodation < ApplicationRecord
  extend Enumerize
  include PgSearch::Model

  CATEGORIES = %i[
    apartment
    house
    villa
    cabin
    loft
    studio
    bungalow
    chalet
    cottage
    beach_house
    other
  ].freeze

  enumerize :category, in: CATEGORIES, predicates: true, scope: true

  belongs_to :owner, class_name: "User"

  has_many :reservations, dependent: :destroy
  has_many :notations, dependent: :destroy
  has_many :user_favorites, dependent: :destroy
  has_many_attached :images
  has_neighbors :embedding
  after_validation :geocode, if: :will_save_change_to_address?
  # after_create :set_embedding

  validates :title, :price, :address, :category, presence: true
  validates :price, numericality: { greater_than: 0 }

  geocoded_by :address
  reverse_geocoded_by :lat, :long

  def city
    Geocoder.search(address).first&.city
  end

  def country
    Geocoder.search(address).first&.country
  end

  def average_note
    notations.average(:note)
  end

  def user_favorite(user)
    user_favorites.find_by(user: user)
  end

  delegate :count, to: :notations, prefix: true

  pg_search_scope :search_by_title_and_description,
                  against: [:title, :description],
                  using: {
                    tsearch: { prefix: true }
                  }

  private

  def set_embedding
    client = OpenAI::Client.new
    response = client.embeddings(
      parameters: {
        model: "text-embedding-3-small",
        input: "Accommodation: #{title},
                Description: #{description},
                Address: #{address},
                Price: #{price},
                Category: #{category.humanize},
                Owner: #{owner.email},
                Average note: #{average_note}"
      }
    )
    embedding = response["data"][0]["embedding"]
    update(embedding:)
  end
end
