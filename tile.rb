require 'oily_png'
require_relative "rpg.rb"

module OHR
  class Tileset

    def initialize rpg, id
      @rpg = rpg
    end

    def palette
      @palette ||= load_master_palette
    end
    def load_master_palette
      file = File.binread("#{@rpg.filename}.rpgdir/palettes.bin")
      filesize = file.unpack("v*")[1]
      palette = file.unpack("C*")[3..2+filesize]   
      (0..255).to_a.map{|i| ChunkyPNG::Color::rgb(palette[3*i], palette[3*i+1], palette[3*i+2]) }
    end

    def tileset id
      @tileset ||= File.binread("#{@rpg.filename}.rpgdir/#{@rpg.archinym}.til", 320*200, id*320*200).unpack("C*").map{|i| palette[i]}
    end

    def draw
      png = ChunkyPNG::Image.new(320, 200)
      (0..3).each do |phase|
        (0...50*320).each do |i|
          png[4*(i%80) + phase, i/80] = tileset(2)[50*320*phase + i]
        end
      end
      png.save("tileset.png", interlace:true)
    end

  end
end

rpg = OHR::RPG.new("spllshrd")

tileset = OHR::Tileset.new(rpg, 1)
tileset.draw