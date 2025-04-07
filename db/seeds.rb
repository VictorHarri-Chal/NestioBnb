# frozen_string_literal: true
require 'open-uri'
require 'tempfile'
require "pexels"

client = Pexels::Client.new(ENV['PEXELS_API_KEY'])

puts "Cleaning database..."
Accommodation.destroy_all
User.destroy_all

10.times do |i|
  puts "Creating user #{i + 1}..."
  User.create!(
    name: Faker::Name.name,
    email: "user#{i + 1}@gmail.com",
    password: "password"
  )
end

# Définir quelques villes populaires avec leurs coordonnées
CITIES = [
  # Europe
  { name: 'London', country: 'United Kingdom', lat: 51.5074, long: -0.1278 },
  { name: 'Paris', country: 'France', lat: 48.8566, long: 2.3522 },
  { name: 'Barcelona', country: 'Spain', lat: 41.3851, long: 2.1734 },
  { name: 'Rome', country: 'Italy', lat: 41.9028, long: 12.4964 },
  { name: 'Amsterdam', country: 'Netherlands', lat: 52.3676, long: 4.9041 },
  { name: 'Berlin', country: 'Germany', lat: 52.5200, long: 13.4050 },
  { name: 'Prague', country: 'Czech Republic', lat: 50.0755, long: 14.4378 },
  { name: 'Venice', country: 'Italy', lat: 45.4408, long: 12.3155 },

  # Americas
  { name: 'New York', country: 'United States', lat: 40.7128, long: -74.0060 },
  { name: 'Los Angeles', country: 'United States', lat: 34.0522, long: -118.2437 },
  { name: 'Miami', country: 'United States', lat: 25.7617, long: -80.1918 },
  { name: 'Rio de Janeiro', country: 'Brazil', lat: -22.9068, long: -43.1729 },

  # Asia
  { name: 'Tokyo', country: 'Japan', lat: 35.6762, long: 139.6503 },
  { name: 'Bangkok', country: 'Thailand', lat: 13.7563, long: 100.5018 },
  { name: 'Singapore', country: 'Singapore', lat: 1.3521, long: 103.8198 },
  { name: 'Dubai', country: 'United Arab Emirates', lat: 25.2048, long: 55.2708 },

  # Oceania
  { name: 'Sydney', country: 'Australia', lat: -33.8688, long: 151.2093 },
  { name: 'Melbourne', country: 'Australia', lat: -37.8136, long: 144.9631 },

  # Autres destinations populaires
  { name: 'Marrakech', country: 'Morocco', lat: 31.6295, long: -7.9811 },
  { name: 'Cape Town', country: 'South Africa', lat: -33.9249, long: 18.4241 }
].freeze

puts "Creating accommodations..."
100.times do |i|
  city = CITIES.sample

  street_number = Faker::Address.building_number
  street_name = Faker::Address.street_name
  address = "#{street_number} #{street_name}, #{city[:name]}, #{city[:country]}"

  accommodation = Accommodation.create!(
    title: "#{Faker::Address.community} - #{[
      'Charming apartment',
      'Luxury villa',
      'Traditional house',
      'Modern loft',
      'Cozy studio',
      'Apartment with view'
    ].sample}",
    description: [
      "This #{['bright', 'spacious', 'renovated', 'modern'].sample} #{Faker::Number.between(from: 30, to: 200)}sqm accommodation offers #{Faker::Number.between(from: 1, to: 5)} bedrooms. ",
      "#{['The fully equipped kitchen', 'The comfortable living room', 'The sunny terrace'].sample} will allow you to #{['make the most of your stay', 'relax after your days out', 'spend pleasant moments'].sample}. ",
      "#{['Ideally located', 'In a quiet neighborhood', 'Close to shops'].sample}, #{['you can easily explore the surroundings', 'all amenities are within walking distance', 'you will appreciate the peaceful setting'].sample}."
    ].join,
    owner: User.all.sample,
    price: Faker::Number.between(from: 50, to: 500),
    address: Faker::Address.street_address,
    category: Accommodation::CATEGORIES.sample
  )

  # Fetch images from Pexels based on the city
  query = "#{city[:name]} #{city[:country]} accommodation"
  photos = []
  begin
    photos = client.photos.search(query, per_page: 15) # Fetch more to get variety
  rescue Pexels::APIError => e
    puts "Pexels API error for query '#{query}': #{e.message}"
  end

  if !photos.any?
    puts "No Pexels images found for query '#{query}'. Skipping image attachment for Accommodation #{accommodation.id}."
  else
    # Get up to 3 photos, but handle case where fewer are available
    photos.first(3).each_with_index do |photo, j|
      image_url = photo.src['large'] # Use 'large' or other appropriate size
      downloaded_image_data = URI.open(image_url).read

      Tempfile.create(['seed_image_', '.jpg'], binmode: true) do |tempfile|
        tempfile.write(downloaded_image_data)
        tempfile.flush

        accommodation.images.attach(
          io: File.open(tempfile.path),
          filename: "seed_image_#{i}_#{j + 1}.jpg",
          content_type: 'image/jpeg'
        )
      end
    end
  end

  puts "Accommodation #{accommodation.id} created in #{city[:name]}"
end

puts "Creating notations..."
Accommodation.all.each do |accommodation|
  20.times do
    Notation.create!(
      accommodation: accommodation,
      user: User.where.not(id: accommodation.owner_id).where.not(email: "user1@gmail.com").sample,
      note: Faker::Number.between(from: 1, to: 5),
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph
    )
  end
end

puts "Finished!"
