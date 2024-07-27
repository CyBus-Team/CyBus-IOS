require 'csv'
require 'json'

class Shape
  attr_accessor :shape_id, :shape_pt_lat, :shape_pt_lon, :shape_pt_sequence

  def initialize(shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence)
    @shape_id = shape_id
    @shape_pt_lat = shape_pt_lat
    @shape_pt_lon = shape_pt_lon
    @shape_pt_sequence = shape_pt_sequence
  end

  def to_hash
    {
      shape_id: @shape_id,
      shape_pt_lat: @shape_pt_lat,
      shape_pt_lon: @shape_pt_lon,
      shape_pt_sequence: @shape_pt_sequence
    }
  end
end

def read_shapes_file(file_path)
  shapes = []
  CSV.foreach(file_path, headers: false, col_sep: ",") do |row|

    shape = Shape.new(
      row[0],
      row[1],
      row[2],
      row[3],
      # shape_id,
      # row['shape_pt_lat'],
      # row['shape_pt_lon'],
      # row['shape_pt_sequence']
    )
    shapes << shape
  end
  shapes
end

def export_shapes_to_json(directories, output_json_path)
  all_shapes = []

  directories.each do |directory|
    shapes_file_path = File.join(directory, 'shapes.txt')
    if File.exist?(shapes_file_path)
      puts "Reading file: #{shapes_file_path}"
      shapes = read_shapes_file(shapes_file_path)
      puts "Found #{shapes.size} shapes in #{shapes_file_path}"
      all_shapes.concat(shapes)
    else
      puts "File not found: #{shapes_file_path}"
    end
  end

  shapes_json = all_shapes.map(&:to_hash).to_json

  File.open(output_json_path, 'w') do |file|
    file.write(shapes_json)
  end

  puts "Exported #{all_shapes.size} shapes to #{output_json_path}"
end

directories = ['Generated/GFTSProviders/2_google_transit', 'Generated/GFTSProviders/4_google_transit', 'Generated/GFTSProviders/5_google_transit', 'Generated/GFTSProviders/6_google_transit', 'Generated/GFTSProviders/9_google_transit', 'Generated/GFTSProviders/10_google_transit', 'Generated/GFTSProviders/11_google_transit']
export_shapes_to_json(directories, 'CyBus/shapes.json')
