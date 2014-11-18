require_relative 'tiledrawer.rb'

FILENAME = "mansion"

if !File.file?("#{FILENAME}.rpgdir/archinym.lmp")
  exec "unlump.exe #{FILENAME}.rpg"
else
  puts "File is already unlumped"
end