require_relative 'mapper.rb'

RPG_NAME = "mansion"

if !File.file?("#{RPG_NAME}.rpgdir/archinym.lmp")
  exec "unlump.exe #{RPG_NAME}.rpg"
else
  puts "File is already unlumped"
end

Mapper.draw_map(RPG_NAME, 0)