require 'json'
require 'rgeo'
require 'rgeo/shapefile'

# Define a structure to store route stop data
class RouteStopEntity
  attr_accessor :id, :latitude, :longitude, :trip_ids

  def initialize(id, latitude, longitude, trip_ids)
    @id = id
    @latitude = latitude
    @longitude = longitude
    @trip_ids = trip_ids
  end

  def to_hash
    {
      id: @id,
      location: {
        latitude: @latitude,
        longitude: @longitude
      },
      trip_ids: @trip_ids
    }
  end

  def inspect
    {
      id: @id,
      location: {
        latitude: @latitude,
        longitude: @longitude
      }.to_s,
      trip_ids: @trip_ids
    }.to_s
  end
end

# Define a structure to store trip data
class TripEntity
  attr_accessor :id, :stops

  def initialize(id, stops)
    @id = id
    @stops = stops
  end

  def to_hash
    {
      id: @id,
      stops: @stops.map(&:to_hash)
    }
  end

  def inspect
    {
      id: @id,
      stops: @stops.map(&:inspect)
    }.to_s
  end
end

# Generate routes and stops based on provided data
def generate_routes_and_stops(trips_file, routes_file, stops_file, stop_times_file, output_file)
  puts "Loading data..."
  trips_data = JSON.parse(File.read(trips_file))
  routes_data = JSON.parse(File.read(routes_file))
  stops_data = JSON.parse(File.read(stops_file))
  stop_times_data = JSON.parse(File.read(stop_times_file))
  puts "Data loaded successfully."

  all_stops = []

  # Get unique trip IDs
  unique_trips = stop_times_data.map { |stop_time| stop_time['trip_id'] }.compact.uniq
  puts "Found #{unique_trips.size} unique trips."

  unique_trips.each_with_index do |trip_id, trip_index|
    puts "Processing trip #{trip_index + 1} of #{unique_trips.size} (ID: #{trip_id})..."

    stop_ids = stop_times_data
                 .select { |stop_time| stop_time['trip_id'] == trip_id }
                 .map { |stop_time| stop_time['stop_id'] }

    stops = stops_data
              .select { |stop| stop_ids.include?(stop['stop_id']) }
              .compact
              .uniq
              .map do |stop|
      trip = trips_data.find { |trip| trip['trip_id'] == trip_id }
      RouteStopEntity.new(
        stop['stop_id'],
        stop['stop_lat'].to_f,
        stop['stop_lon'].to_f,
        routes_data
          .select { |route| route['line_id'] == trip['route_id'] }
          .map { |route| route['line_id'] }
      )
    end

    puts "  Found #{stops.size} stops for trip #{trip_id}."

    all_stops.concat(stops)
  end

  puts "Total stops processed: #{all_stops.size}"

  all_trips = trips_data.map { |trip| trip['route_id'] }.uniq.map.with_index do |route_id, index|
    puts "Processing route #{index + 1} of #{trips_data.size} (Route ID: #{route_id})..."
    line_id = routes_data.find { |route| route['line_id'] == route_id }&.fetch('line_id', nil)
    stops_for_route = all_stops.select { |stop| stop.trip_ids.include?(line_id) }
    puts "  Found #{stops_for_route.size} stops for route #{route_id}."
    TripEntity.new(line_id, stops_for_route)
  end

  puts "Total routes processed: #{all_trips.size}"

  all_data = all_trips.map(&:to_hash).to_json
  puts "All data size: #{all_data.size}"

  File.open(output_file, 'w') do |file|
    puts "Writing data to #{output_file}..."
    file.write(all_trips.map(&:to_hash).to_json)
  end

  puts "Data successfully written to #{output_file}."
end

# Example usage
generate_routes_and_stops(
  'CyBus/trips.json',
  'CyBus/routes.json',
  'CyBus/stops.json',
  'CyBus/stop_times.json',
  'CyBus/paths.json'
)