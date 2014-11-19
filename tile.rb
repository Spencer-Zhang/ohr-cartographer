require 'oily_png'
require_relative "rpg.rb"

module OHR
  class Tile

    def initialize rpg
      @rpg = rpg
    end

    def load_master_palette
      file = File.binread("#{@rpg.filename}.rpgdir/palettes.bin")
      filesize = file.unpack("v*")[1]
      palette = file.unpack("C*")[3..2+filesize]   
      (0..255).to_a.map{|i| ChunkyPNG::Color::rgb(palette[3*i], palette[3*i+1], palette[3*i+2]) }
    end

    def load_tileset id

    end

  end
end

rpg = OHR::RPG.new("spllshrd")

tile = OHR::Tile.new(rpg)
p tile.load_tileset 1