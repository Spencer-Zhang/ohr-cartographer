require "oily_png"

class Mapper

  def self.get_archinym rpg_name
    p "test"
    File.open("#{rpg_name}.rpgdir/archinym.lmp", &:readline).chomp
  end

  def self.draw_map rpg_name, map_id

    archinym = get_archinym rpg_name

    if(map_id < 10)
      filename = "#{archinym}.t0#{map_id}"
    elsif(map_id < 100)
      filename = "#{archinym}.t#{map_id}"
    else
      filename = "#{map_id}.t"
    end

    file = File.binread("#{rpg_name}.rpgdir/#{archinym}.t01", nil, 7)
    width  = file.unpack("v*")[0]
    height = file.unpack("v*")[1]

    tilemap = file.unpack("C*")[4..3+width*height]

    png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::WHITE)
    (width*height).times do |i|
      png[i%width, i/width] = ChunkyPNG::Color::rgb(tilemap[i], tilemap[i], tilemap[i])
    end

    Dir.mkdir("maps") unless File.exists?("maps")
    png.save("maps/#{rpg_name}-#{map_id}.png", interlace: true)
  end

end