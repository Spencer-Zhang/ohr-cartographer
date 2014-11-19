require "oily_png"
require_relative "tile"

module OHR
  class Map

    def initialize rpg, map_id
      @rpg = rpg
      @map_id = map_id
      @filename = get_lump_name
      load_tilemap
    end

    def get_lump_name
      if(@map_id < 10)
        "#{@rpg.archinym}.t0#{@map_id}"
      elsif(@map_id < 100)
        "#{@rpg.archinym}.t#{@map_id}"
      else
        "#{@map_id}.t"
      end
    end

    def load_tilemap
      file = File.binread("#{@rpg.filename}.rpgdir/#{get_lump_name}", nil, 7)
      @width  = file.unpack("v*")[0]
      @height = file.unpack("v*")[1]
      @tilemap = file.unpack("C*")[4..3+@width*@height]
    end


    def draw
      png = ChunkyPNG::Image.new(20*@width, 20*@height, ChunkyPNG::Color::WHITE)
      tileset = OHR::Tileset.new(@rpg, 0)

      (@width*@height).times do |i|
        tile = tileset.load_tile(@tilemap[i])

        (0..399).each do |j|
          png[(20*(i%@width) + j%20), (20*(i/@width) + j/20)] = tile[j]
        end
      end
      Dir.mkdir("maps") unless File.exists?("maps")
      png.save("maps/#{@rpg.filename}-#{@map_id}.png", interlace: true)
    end

  end
end