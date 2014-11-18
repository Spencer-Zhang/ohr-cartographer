require 'oily_png'

class Tile

  def self.load_master_palette
    file = File.binread("spllshrd.rpgdir/palettes.bin")
    filesize = file.unpack("v*")[1]
    palette = file.unpack("C*")[3..2+filesize]
    
    (0..255).to_a.map{|i| ChunkyPNG::Color::rgb(palette[3*i], palette[3*i+1], palette[3*i+2]) }
  end

end
