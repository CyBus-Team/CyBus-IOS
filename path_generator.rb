require 'json'
require 'rgeo'
require 'rgeo/shapefile'

# Define a structure to store route stop data
class RouteStopEntity
  attr_accessor :id, :latitude, :longitude, :route_ids

  def initialize(id, latitude, longitude, route_ids)
    @id = id
    @latitude = latitude
    @longitude = longitude
    @route_ids = route_ids
  end

  def to_hash
    {
      id: @id,
      location: {
        latitude: @latitude,
        longitude: @longitude
      },
      route_ids: @route_ids
    }
  end

  def inspect
    {
      id: @id,
      location: @location,
    #   route_ids: @route_ids
    }.to_s
  end

end

# Define a structure to store route data
class RouteEntity
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

  #   def to_s
#     "RouteEntity(id: #{@id}, stops: #{@stops.size}, shapes: #{@shapes.size})"
#   end
def inspect
    {
      id: @id,
      stops: @stops.map(&:inspect),
      shapes: @shapes
    }.to_s
  end
end

# Generate routes and stops based on provided data
def generate_routes_and_stops(trips_file, routes_file, stops_file, stop_times_file, output_file)
  # Load JSON data from files
  trips_data = JSON.parse(File.read(trips_file))
  routes_data = JSON.parse(File.read(routes_file))
  stops_data = JSON.parse(File.read(stops_file))
  stop_times_data = JSON.parse(File.read(stop_times_file))

  all_stops = []

  # Get unique trip IDs
  unique_trips = stop_times_data.map { |stop_time| stop_time['trip_id'] }.compact.uniq.take(1)

  puts "unique_trips #{unique_trips.size}"
  puts "first #{unique_trips.take(1).inspect}"

  unique_trips.each_with_index do |trip_id, trip_index|
    # puts "Processing trip #{trip_index + 1} of #{unique_trips.size}"

    # Get stop IDs for the current trip
    stop_ids = stop_times_data
                .select { |stop_time| stop_time['trip_id'] == trip_id }
                .map { |stop_time| stop_time['stop_id'] }

    # Get stops for the current trip
    stops = stops_data
             .select { |stop| stop_ids.include?(stop['stop_id']) }
             .compact
             .uniq
             .map do |stop|
      RouteStopEntity.new(
        stop['stop_id'],
        stop['latitude'].to_f,
        stop['longitude'].to_f,
        routes_data
          .select { |route| route['line_id'] == trip_id }
          .map { |route| route['line_id'] }
      )
    end

    puts "#{stops.size} stops"
    all_stops.concat(stops)
  end

  puts "All stops: #{all_stops.size}"

  # Generate routes with stops
  all_routes = routes_data.map do |route|
    stops_for_route = all_stops.select { |stop| stop.route_ids.include?(route['line_id']) }
    RouteEntity.new(route['line_id'], stops_for_route)
  end

  puts "All routes: #{all_routes.size}"

#   all_routes.map do |route|
#     puts "Route: #{route.inspect}"
#     break
#   end
#   puts "First #{all_routes[0].inspect}"

  all_data = all_routes.map(&:to_hash).to_json

  puts "All data: #{all_data.size}"

  # Write output to file
  File.open(output_file, 'w') do |file|
    file.write(all_routes.map(&:to_hash).to_json)
  end
end

# Example usage
generate_routes_and_stops(
  'CyBus/trips.json',      # JSON file with trips data
  'CyBus/routes.json',      # JSON file with routes data
  'CyBus/stops.json',       # JSON file with stops data
  'CyBus/stop_times.json',  # JSON file with stop times data
  'CyBus/paths.json' # Output file
)