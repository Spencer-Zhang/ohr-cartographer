require 'oily_png'
require_relative "rpg.rb"

def draw_png array, width, height
  png = ChunkyPNG::Image.new(width, height)
  (width*height).times do |i|
    png[i%width, i/width] = array[i]
  end
  png.save("test.png", interlace:true)
end


module OHR
  class Tileset

    attr_reader :animation
    def initialize rpg, id
      @rpg = rpg
      @tileset_id = id
      tileset(id)

      file = File.binread("#{@rpg.path}.rpgdir/#{@rpg.archinym}.tap", 80, 80*id)
      if file
        @animation = [file.unpack("v*")[0], file.unpack("v*")[20]]
      end
    end

    def palette
      @palette ||= load_master_palette
    end
    def load_master_palette
      id = File.binread("#{@rpg.path}.rpgdir/#{@rpg.archinym}.gen", nil, 7).unpack("v*")[78]

      if(File.exists? "#{@rpg.path}.rpgdir/palettes.bin")
        file = File.binread("#{@rpg.path}.rpgdir/palettes.bin")
        filesize = file.unpack("v*")[1]
        palette = file.unpack("C*")[filesize*id + 4..filesize*id + 3+filesize]
        (0..255).to_a.map{|i| ChunkyPNG::Color::rgb(palette[3*i], palette[3*i+1], palette[3*i+2]) }
      else
        file = File.binread("#{@rpg.path}.rpgdir/#{@rpg.archinym}.mas", nil, 7)
        palette = file.unpack("v*")[0...1536/2]
        p palette[0..19]
        (0..255).to_a.map{|i| ChunkyPNG::Color::rgb(palette[3*i]*4, palette[3*i+1]*4, palette[3*i+2]*4) }
      end
    end

    def tileset id
      @tileset ||= []
      @tileset[id] ||= File.binread("#{@rpg.path}.rpgdir/#{@rpg.archinym}.til", 320*200, id*320*200).unpack("C*").map{|i| i == 0 ? nil : palette[i]}
    end

    def draw
      png = ChunkyPNG::Image.new(80, 800)
      (0...200*320).each do |i|
        png[i%80, i/80] = tileset(0)[i]
      end
      png.save("tileset.png", interlace:true)
    end

    def load_tile id
      tile = []
      temp = []
      (0..399).each do |i|
        phase = i%4
        index = i/4
        tile[4*index+phase] = tileset(@tileset_id)[index%5 + 80*(index/5) + 80*200*phase + 5*(id%16) + 80*20*(id/16)]
      end

      return tile
    end

  end
end
