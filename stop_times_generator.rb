require 'csv'
require 'json'

class StopTime
  attr_accessor :trip_id, :arrival_time, :departure_time, :stop_id, :stop_sequence

  def initialize(trip_id, arrival_time, departure_time, stop_id, stop_sequence)
    @trip_id = trip_id
    @arrival_time = arrival_time
    @departure_time = departure_time
    @stop_id = stop_id
    @stop_sequence = stop_sequence
  end

  def to_hash
    {
      trip_id: @trip_id,
      arrival_time: @arrival_time,
      departure_time: @departure_time,
      stop_id: @stop_id,
      stop_sequence: @stop_sequence
    }
  end
end

def read_stop_times_file(file_path)
  stop_times = []
  CSV.foreach(file_path, headers: true, col_sep: ",") do |row|
    stop_time = StopTime.new(
      row[0],
      row[1],
      row[2],
      row[3],
      row[4]
      # row['trip_id'],
      # row['arrival_time'],
      # row['departure_time'],
      # row['stop_id'],
      # row['stop_sequence']
    )
    stop_times << stop_time
  end
  stop_times
end

def export_stop_times_to_json(directories, output_json_path)
  all_stop_times = []

  directories.each do |directory|
    stop_times_file_path = File.join(directory, 'stop_times.txt')
    if File.exist?(stop_times_file_path)
      puts "Reading file: #{stop_times_file_path}"
      stop_times = read_stop_times_file(stop_times_file_path)
      puts "Found #{stop_times.size} stop times in #{stop_times_file_path}"
      all_stop_times.concat(stop_times)
    else
      puts "File not found: #{stop_times_file_path}"
    end
  end

  stop_times_json = all_stop_times.map(&:to_hash).to_json

  File.open(output_json_path, 'w') do |file|
    file.write(stop_times_json)
  end

  puts "Exported #{all_stop_times.size} stop times to #{output_json_path}"
end

directories = ['Generated/GFTSProviders/2_google_transit', 'Generated/GFTSProviders/4_google_transit', 'Generated/GFTSProviders/5_google_transit', 'Generated/GFTSProviders/6_google_transit', 'Generated/GFTSProviders/9_google_transit', 'Generated/GFTSProviders/10_google_transit', 'Generated/GFTSProviders/11_google_transit']
export_stop_times_to_json(directories, 'CyBus/stop_times.json')
