require_relative 'lib/rpg'
require_relative 'lib/map'

begin
  if(ARGV[0])
    rpg_name = File.basename(ARGV[0]).split(".")[0]
    rpg = OHR::RPG.new(rpg_name)

    data_size = File.binread("#{rpg.filename}.rpgdir/binsize.bin").unpack("v*")[4]
    n_maps = File.size("#{rpg.filename}.rpgdir/#{rpg.archinym}.map")/data_size

    loop do
      puts "\nPlease enter the id of the map you want to print (0-#{n_maps-1})"
      puts "Type 'all' to print all the maps."
      puts "Type 'quit' to close this program."
      puts ""
      print "> "

      input = STDIN.gets.chomp.downcase

      if input == "all"
        n_maps.times do |i|
          puts "Drawing map #{i}"
          map = OHR::Map.new(rpg, i)
          map.draw
        end
      elsif input.to_i.to_s == input
        puts "Drawing map #{input}"
        map = OHR::Map.new(rpg, input.to_i)
        map.draw
      elsif input == "quit"
        break
      else
        puts "Invalid input, please try again.\n"
      end
    end
  else
    puts "You must enter an rpg-file"
    puts "Usage: ruby main.rb <rpg-name>"
  end
rescue Exception => e
  puts e.message
  puts e.backtrace.inspect
end

puts "\nPress Enter to continue...\n"
STDIN.gets