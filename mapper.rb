require "oily_png"

class Mapper

  def self.draw_map rpg_name, map_id

    if(map_id < 10)
      filename = "ohrrpgce.t0#{map_id}"
    elsif(map_id < 100)
      filename = "ohrrpgce.t#{map_id}"
    else
      filename = "#{map_id}.t"
    end

    file = File.binread("#{rpg_name}.rpgdir/ohrrpgce.t00", nil, 7)
    width  = file.unpack("v*")[0]
    height = file.unpack("v*")[1]

    tilemap = file.unpack("C*")[4..3+width*height]

    png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)
    (width*height).times do |i|
      png[i%width, i/width] = ChunkyPNG::Color::rgb(tilemap[i], tilemap[i], tilemap[i])
    end

    Dir.mkdir("maps") unless File.exists?("maps")
    png.save("maps/#{map_id}.png", interlace: true)
  end

end