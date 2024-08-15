require 'csv'
require 'json'

class Stop
  attr_accessor :stop_id, :stop_name, :stop_lat, :stop_lon

  def initialize(stop_id, stop_name, stop_lat, stop_lon)
    @stop_id = stop_id
    @stop_name = stop_name
    @stop_lat = stop_lat
    @stop_lon = stop_lon
  end

  def to_hash
    {
      stop_id: @stop_id,
      stop_name: @stop_name,
      stop_lat: @stop_lat,
      stop_lon: @stop_lon
    }
  end
end

def read_stops_file(file_path)
  stops = []
  CSV.foreach(file_path, headers: true, col_sep: ",") do |row|
    stop = Stop.new(
      row['stop_id'],
      row['stop_name'],
      row['stop_lat'],
      row['stop_lon']
    )
    stops << stop
  end
  stops
end

def export_stops_to_json(directories, output_json_path)
  all_stops = []

  directories.each do |directory|
    stops_file_path = File.join(directory, 'stops.txt')
    if File.exist?(stops_file_path)
      puts "Reading file: #{stops_file_path}"
      stops = read_stops_file(stops_file_path)
      puts "Found #{stops.size} stops in #{stops_file_path}"
      all_stops.concat(stops)
    else
      puts "File not found: #{stops_file_path}"
    end
  end

  stops_json = all_stops.map(&:to_hash).to_json

  File.open(output_json_path, 'w') do |file|
    file.write(stops_json)
  end

  puts "Exported #{all_stops.size} stops to #{output_json_path}"
end

directories = ['Generated/GFTSProviders/2_google_transit', 'Generated/GFTSProviders/4_google_transit', 'Generated/GFTSProviders/5_google_transit', 'Generated/GFTSProviders/6_google_transit', 'Generated/GFTSProviders/9_google_transit', 'Generated/GFTSProviders/10_google_transit', 'Generated/GFTSProviders/11_google_transit']
export_stops_to_json(directories, 'CyBus/stops.json')
