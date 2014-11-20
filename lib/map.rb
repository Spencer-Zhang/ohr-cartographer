require "oily_png"
require_relative "tileset"

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
      
      default_tileset = file.unpack("v*")[0]
      tileset = []
      tileset[0] = file.unpack("v*")[22]
      tileset[1] = file.unpack("v*")[23]
      tileset[2] = file.unpack("v*")[24]
      tileset[3] = file.unpack("v*")[26]
      tileset[4] = file.unpack("v*")[27]
      tileset[5] = file.unpack("v*")[28]
      tileset[6] = file.unpack("v*")[29]
      tileset[7] = file.unpack("v*")[30]
      tileset.map!{|layer| layer == 0 ? default_tileset : layer-1}

      return tileset
    end


    def load_tilemap
      file = File.binread("#{@rpg.filename}.rpgdir/#{get_lump_name}", nil, 7)
      @width  = file.unpack("v*")[0]
      @height = file.unpack("v*")[1]

      @n_layers = file.unpack("C*").size / (@width * @height)
      @tilemap = file.unpack("C*")[4..3+@n_layers*@width*@height]
    end


    def draw
      tileset = OHR::Tileset.new(@rpg, @tileset[0])
      png = ChunkyPNG::Image.new(20*@width, 20*@height, tileset.palette[0])

      @n_layers.times do |layer|
        tileset = OHR::Tileset.new(@rpg, @tileset[layer]) if layer > 0

        (@width*@height).times do |i|
          tile_id = @tilemap[i + layer*@width*@height]

          if tile_id > 208
            tile_id = tile_id - 208 + tileset.animation[1]
          elsif tile_id > 160
            tile_id = tile_id - 160 + tileset.animation[0]
          end

          if layer == 0 || tile_id > 0
            tile = tileset.load_tile(tile_id)

            (0..399).each do |j|
              png.set_pixel(20*(i % @width) + j%20, (20*(i/@width) + j/20), tile[j]) if tile[j] != nil
            end
          end

        end
      end
      Dir.mkdir("maps") unless File.exists?("maps")
      png.save("maps/#{@rpg.filename}-#{@map_id}.png", interlace: true)
    end

  end
end
