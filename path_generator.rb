require 'json'

CITIES = JSON.parse(File.read('CyBus/cities.json'))

def find_nearest_city(latitude, longitude)
  CITIES.min_by do |city|
    (city['latitude'] - latitude).abs + (city['longitude'] - longitude).abs
  end['name']
end

class StopEntity
  attr_accessor :id, :longitude, :latitude, :trip_ids, :city

  def initialize(id, longitude, latitude, trip_ids, city)
    @id = id
    @longitude = longitude
    @latitude = latitude
    @trip_ids = trip_ids
    @city = city
  end

  def to_hash
    {
      id: @id,
      longitude: @longitude,
      latitude: @latitude,
      trip_ids: @trip_ids,
      city: @city
    }
  end
end

class TripEntity
  attr_accessor :id, :stops, :city

  def initialize(id, stops, city)
    @id = id
    @stops = stops
    @city = city
  end

  def to_hash
    {
      id: @id,
      stops: @stops,
      city: @city
    }
  end
end

def generate_stops(stops_file, stop_times_file, output_file)
  puts("Generate stops...")

  stops_data = JSON.parse(File.read(stops_file))
  stop_times_data = JSON.parse(File.read(stop_times_file))

  all_stops = []
  uniq_stops_ids = stop_times_data.map { |stop_time| stop_time['stop_id'] }.uniq

  uniq_stops_ids.each_with_index do |stop_id, index|
    puts "Processing stop #{index + 1} of #{uniq_stops_ids.size}" if index % 1000 == 0

    found_stop = stops_data.find { |stop| stop['stop_id'] == stop_id }
    found_stop_id = found_stop['stop_id']
    found_stop_times = stop_times_data.select { |stop_time| stop_time["stop_id"] == found_stop_id }
    found_trip_ids = found_stop_times.map { |stop_time| stop_time['trip_id'] }.uniq

    city = find_nearest_city(found_stop['stop_lat'].to_f, found_stop['stop_lon'].to_f)

    converted = StopEntity.new(
      found_stop_id,
      found_stop['stop_lon'].to_f,
      found_stop['stop_lat'].to_f,
      found_trip_ids,
      city
    )

    all_stops.append(converted)
  end

  all_data = all_stops.map(&:to_hash).to_json
  File.open(output_file, 'w') { |file| file.write(all_data) }
  puts "Stops data successfully written to #{output_file}."
end

def generate_trips(trip_stops_file, trips_file, output_file)
  puts("Generate trips...")

  trip_stops_data = JSON.parse(File.read(trip_stops_file))
  trips_data = JSON.parse(File.read(trips_file))

  all_trips = []
  uniq_trip_ids = trips_data.map { |trip| trip['trip_id'] }.uniq

  uniq_trip_ids.each_with_index do |trip_id, index|
    puts "Processing trip_id #{index + 1} of #{uniq_trip_ids.size}" if index % 1000 == 0

    found_stops = trip_stops_data.select { |stop| stop["trip_ids"].include?(trip_id) }

    if found_stops.empty?
      city = nil
    else
      city = found_stops.map { |stop| stop["city"] }.uniq
      city = city.length == 1 ? city.first : "Multiple Cities"
    end

    converted = TripEntity.new(
      trip_id,
      found_stops.map { |stop| stop["id"] },
      city
    )

    all_trips.append(converted)
  end

  all_data = all_trips.map(&:to_hash).to_json
  File.open(output_file, 'w') { |file| file.write(all_data) }
  puts "Trips data successfully written to #{output_file}."
end

generate_stops(
  'CyBus/stops.json',
  'CyBus/stop_times.json',
  'CyBus/trip_stops.json'
)
generate_trips(
  'CyBus/trip_stops.json',
  'CyBus/trips.json',
  'CyBus/all_trips.json'
)