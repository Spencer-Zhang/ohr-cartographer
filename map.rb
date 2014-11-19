require "oily_png"
require_relative "tile"

module OHR
  class Map

    def initialize rpg, map_id
      @rpg = rpg
      @map_id = map_id
      @filename = get_lump_name
      @tileset = get_tileset
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


    def get_tileset
      data_size = File.binread("#{@rpg.filename}.rpgdir/binsize.bin").unpack("v*")[4]
      file = File.binread("#{@rpg.filename}.rpgdir/#{@rpg.archinym}.map", data_size, @map_id * data_size)
      tileset = file.unpack("v*")[22] - 1
      tileset = file.unpack("v*")[0] if tileset <= 0
      return tileset
    end


    def load_tilemap
      file = File.binread("#{@rpg.filename}.rpgdir/#{get_lump_name}", nil, 7)
      @width  = file.unpack("v*")[0]
      @height = file.unpack("v*")[1]
      @tilemap = file.unpack("C*")[4..3+@width*@height]
    end


    def draw
      tileset = OHR::Tileset.new(@rpg, @tileset)
      png = ChunkyPNG::Image.new(20*@width, 20*@height, tileset.palette[0])

      (@width*@height).times do |i|
        tile_id = @tilemap[i]

        if tile_id > 208
          tile_id = tile_id - 208 + tileset.animation[1]
        elsif tile_id > 160
          tile_id = tile_id - 160 + tileset.animation[0]
        end

        tile = tileset.load_tile(tile_id)

        (0..399).each do |j|
          png.set_pixel(20*(i % @width) + j%20, (20*(i/@width) + j/20), tile[j]) if tile[j] != nil
        end

      end
      Dir.mkdir("maps") unless File.exists?("maps")
      png.save("maps/#{@rpg.filename}-#{@map_id}.png", interlace: true)
    end

  end
end
