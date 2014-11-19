require_relative 'rpg.rb'
require_relative 'map.rb'

if(ARGV[0])
  rpg_name = ARGV[0].split(".")[0]

  rpg = OHR::RPG.new(rpg_name)

  map = OHR::Map.new(rpg, 0)
  map.draw

end