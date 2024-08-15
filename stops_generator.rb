require 'csv'
require 'json'
require 'set'

class Stop
  attr_accessor :stop_id, :stop_code, :stop_name, :stop_desc, :stop_lat, :stop_lon, :zone_id

  def initialize(stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id)
    @stop_id = stop_id
    @stop_code = stop_code
    @stop_name = stop_name
    @stop_desc = stop_desc
    @stop_lat = stop_lat
    @stop_lon = stop_lon
    @zone_id = zone_id
  end

  def to_hash
    {
      stop_id: @stop_id,
      stop_code: @stop_code,
      stop_name: @stop_name,
      stop_desc: @stop_desc,
      stop_lat: @stop_lat,
      stop_lon: @stop_lon,
      zone_id: @zone_id
    }
  end
end

def read_stops_file(file_path, known_stop_ids)
  stops = []
  CSV.foreach(file_path, headers: true, col_sep: ",") do |row|
    stop_id = row[0].strip.downcase
    next if known_stop_ids.include?(stop_id)

    stop = Stop.new(
      stop_id,  # stop_id
      row[1],  # stop_code
      row[2],  # stop_name
      row[3],  # stop_desc
      row[4],  # stop_lat
      row[5],  # stop_lon
      row[6]   # zone_id
    )
    stops << stop
    known_stop_ids.add(stop_id)
  end
  stops
end

def export_stops_to_json(directories, output_json_path)
  all_stops = []
  known_stop_ids = Set.new

  directories.each do |directory|
    stops_file_path = File.join(directory, 'stops.txt')
    if File.exist?(stops_file_path)
      puts "Reading file: #{stops_file_path}"
      stops = read_stops_file(stops_file_path, known_stop_ids)
      puts "Found #{stops.size} unique stops in #{stops_file_path}"
      all_stops.concat(stops)
    else
      puts "File not found: #{stops_file_path}"
    end
  end

  stops_json = all_stops.map(&:to_hash).to_json

  File.open(output_json_path, 'w') do |file|
    file.write(stops_json)
  end

  puts "Exported #{all_stops.size} unique stops to #{output_json_path}"
end

directories = ['Generated/GFTSProviders/2_google_transit', 'Generated/GFTSProviders/4_google_transit', 'Generated/GFTSProviders/5_google_transit', 'Generated/GFTSProviders/6_google_transit', 'Generated/GFTSProviders/9_google_transit', 'Generated/GFTSProviders/10_google_transit', 'Generated/GFTSProviders/11_google_transit']
export_stops_to_json(directories, 'CyBus/stops.json')
