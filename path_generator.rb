require 'json'
require 'rgeo'
require 'rgeo/shapefile'

# Define a structure to store stop data
class StopEntity
  attr_accessor :id, :longitude, :latitude, :trip_ids

  def initialize(id, longitude, latitude , trip_ids)
    @id = id
    @longitude = longitude
    @latitude = latitude
    @trip_ids = trip_ids
  end

  def to_hash
    {
      id: @id,
      longitude: @longitude,
      latitude: @latitude,
      trip_ids: @trip_ids
    }
  end

  def inspect
    {
      id: @id,
      longitude: @longitude,
      latitude: @latitude,
      trip_ids: @trip_ids
    }.to_s
  end
end

# Define a structure to store trip data
class TripEntity
  attr_accessor :id, :stops, :shapes

  def initialize(id, stops, shapes)
    @id = id
    @stops = stops
    @shapes = shapes
  end

  def to_hash
    {
      id: @id,
      stops: @stops,
      shapes: @shapes.map(&:to_hash)
    }
  end

  def inspect
    {
      id: @id,
      stops: @stops.map(&:inspect),
      shapes: @stops.map(&:inspect)
    }.to_s
  end
end

# Define a structure to store shape data
class ShapeEntity
  attr_accessor :id, :longitude, :latitude, :sequence

  def initialize(id, longitude, latitude, sequence)
    @id = id
    @longitude = longitude
    @latitude = latitude
    @sequence = sequence
  end

  def to_hash
    {
      id: @id,
      longitude: @longitude,
      latitude: @latitude,
      sequence: @sequence
    }
  end

  def inspect
    {
      id: @id,
      longitude: @longitude,
      latitude: @latitude,
      sequence: @sequence
    }.to_s
  end
end

def generate_stops(stops_file, stop_times_file, output_file)
  puts("Generate stops...")

  stops_data = JSON.parse(File.read(stops_file))
  stop_times_data = JSON.parse(File.read(stop_times_file))

  # @type [Array<StopEntity>]
  all_stops = []

  # @type [Array<String>]
  uniq_stops_ids = stop_times_data.map { |stop_time| stop_time['stop_id'] }.uniq

  uniq_stops_ids.each_with_index do |stop_id, index|
    if index % 1000 == 0
      puts "Processing stop #{index + 1} of #{uniq_stops_ids.size}: stop_id=#{stop_id}"
    end

    found_stop = stops_data.find { |stop| stop['stop_id'] == stop_id }
    found_stop_id = found_stop['stop_id']
    found_stop_times = stop_times_data.select { |stop_time| stop_time["stop_id"] == found_stop_id }
    found_trip_ids = found_stop_times.map { |stop_time| stop_time['trip_id'] }.uniq

    converted = StopEntity.new(
      found_stop_id,
      found_stop['stop_lon'].to_f,
      found_stop['stop_lat'].to_f,
      found_trip_ids
    )

    all_stops.append(converted)
  end

  all_data = all_stops.map(&:to_hash).to_json

  File.open(output_file, 'w') do |file|
    puts "Writing data to #{output_file}..."
    file.write(all_data)
  end

  puts "Stops data successfully written to #{output_file}."

end

def generate_trips(trip_stops_file, trips_file, shapes_file, output_file)
  puts("Generate trips...")

  trip_stops_data = JSON.parse(File.read(trip_stops_file))
  trips_data = JSON.parse(File.read(trips_file))
  shapes_data = JSON.parse(File.read(shapes_file))

  # @type [Array<TripEntity>]
  all_trips = []

  # @type [Array<String>]
  uniq_trip_ids = trips_data.map { |trip| trip['trip_id'] }.uniq

  uniq_trip_ids.each_with_index do |trip_id, index|
    if index % 1000 == 0
      puts "Processing trip_id #{index + 1} of #{uniq_trip_ids.size}"
    end

    found_stops = trip_stops_data.select { |stop| stop["trip_ids"].include?(trip_id) }.map { |stop| stop["id"] }

    trip = trips_data[index]
    route_id = trip["route_id"]
    found_shapes = shapes_data.select { |shape| shape["shape_id"] == route_id }
    # @type [Array<ShapeEntity>]
    converted_shapes = found_shapes.map { |shape| ShapeEntity.new(
                         shape["shape_id"],
                         shape["shape_pt_lot"],
                         shape["shape_pt_lat"],
                         shape["shape_pt_sequence"].to_i
                       )}

    converted = TripEntity.new(
      trip_id,
      found_stops,
      converted_shapes,
    )

    all_trips.append(converted)
  end

  all_data = all_trips.map(&:to_hash).to_json

  File.open(output_file, 'w') do |file|
    puts "Writing data to #{output_file}..."
    file.write(all_data)
  end

  puts "Trips data successfully written to #{output_file}."
end

# Example usage
generate_stops(
  'CyBus/stops.json',
  'CyBus/stop_times.json',
  'CyBus/trip_stops.json'
)
generate_trips(
  'CyBus/trip_stops.json',
  'CyBus/trips.json',
  'CyBus/shapes.json',
  'CyBus/all_trips.json'
)