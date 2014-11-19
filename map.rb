require "oily_png"

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
      file = File.binread("#{@rpg.filename}.rpgdir/#{@rpg.archinym}.t01", nil, 7)
      @width  = file.unpack("v*")[0]
      @height = file.unpack("v*")[1]
      @tilemap = file.unpack("C*")[4..3+@width*@height]
    end


    def draw
      png = ChunkyPNG::Image.new(@width, @height, ChunkyPNG::Color::WHITE)
      (@width*@height).times do |i|
        png[i%@width, i/@width] = ChunkyPNG::Color::rgb(@tilemap[i], @tilemap[i], @tilemap[i])
      end
      Dir.mkdir("maps") unless File.exists?("maps")
      png.save("maps/#{@rpg.filename}-#{@map_id}.png", interlace: true)
    end

  end
end