require_relative 'rpg.rb'
require_relative 'map.rb'
require 'benchmark'

if(ARGV[0])
  rpg_name = ARGV[0].split(".")[0]

  rpg = OHR::RPG.new(rpg_name)

  data_size = File.binread("#{rpg.filename}.rpgdir/binsize.bin").unpack("v*")[4]
  n_maps = File.size("#{rpg.filename}.rpgdir/#{rpg.archinym}.map")/data_size

  if(ARGV[1] == nil)
    p "This game has #{n_maps} maps."
  elsif(ARGV[1] == "all")
    n_maps.times do |i|
      p "Drawing map #{i}"
      map = OHR::Map.new(rpg, i)
      map.draw
    end
  elsif(ARGV[1].to_i.to_s == ARGV[1])
    map = OHR::Map.new(rpg, ARGV[1].to_i)
    map.draw
  end
end