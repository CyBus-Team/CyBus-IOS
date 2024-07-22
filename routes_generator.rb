require 'rgeo'
require 'rgeo/shapefile'
require 'json'

# Define a structure to store route data
class Route
  attr_accessor :line_id, :line_name, :route_name, :first_stop, :last_stop, :direction, :line_length

  def initialize(line_id, line_name, route_name, first_stop, last_stop, direction, line_length)
    @line_id = line_id
    @line_name = line_name
    @route_name = route_name
    @first_stop = first_stop
    @last_stop = last_stop
    @direction = direction
    @line_length = line_length
  end

  def to_hash
    {
      line_id: @line_id,
      line_name: @line_name,
      route_name: @route_name,
      first_stop: @first_stop,
      last_stop: @last_stop,
      direction: @direction,
      line_length: @line_length
    }
  end
end

# Function to read Shapefile and export data to JSON
def export_shapefile_to_json(shapefile_path, json_path)
  factory = RGeo::Geographic.simple_mercator_factory
  routes = []

  # Check if all necessary files exist
  ['.shp', '.shx', '.dbf', '.prj'].each do |ext|
    file_path = shapefile_path.sub('.shp', ext)
    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      return
    end
  end

  # Open the Shapefile and iterate over each record
  RGeo::Shapefile::Reader.open(shapefile_path, factory: factory) do |file|
    file.each do |record|
      line_id = record['LINE_ID']
      line_name = record['LINE_NAME']
      route_name = record['ROUTE_NAME']
      first_stop = record['FIRST_STOP']
      last_stop = record['LAST_STOP']
      direction = record['DIRECTION']
      line_length = record['LINE_LENGT']

      # Create a new Route object and add it to the routes array
      route = Route.new(line_id, line_name, route_name, first_stop, last_stop, direction, line_length)
      routes << route
    end
  end

  # Convert the routes array to JSON
  routes_json = routes.map(&:to_hash).to_json

  # Write the JSON data to a file
  File.open(json_path, 'w') do |file|
    file.write(routes_json)
  end
end

# Example usage of the function
export_shapefile_to_json('Generated/routes.shp', 'CyBys/routes.json')
