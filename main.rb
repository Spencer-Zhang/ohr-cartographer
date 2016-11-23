require_relative 'lib/rpg'
require_relative 'lib/map'



def parse_input input
  return nil if input =~ /[^\d\-\,\s]/

  output = []
  phrases = input.chomp.split(",")

  phrases.each do |phrase|
    numbers = phrase.split("-")

    if numbers.size == 1
      output.push numbers[0].strip.to_i
    elsif numbers.size == 2
      output += (numbers[0].strip.to_i..numbers[1].strip.to_i).to_a
    else
      return nil
    end

  end

  return output.uniq.sort
end


begin
  if(ARGV[0])
    rpg_path = ARGV[0]
    rpg = OHR::RPG.new(rpg_path)

    data_size = rpg.map_size
    n_maps = File.size("#{rpg.path}.rpgdir/#{rpg.archinym}.map")/data_size

    loop do
      puts "\nPlease enter the id of the map you want to print (0-#{n_maps-1})"
      puts "You can enter a list or range of maps to be printed"
      puts "(i.e. '4-8, 10, 12')"
      puts "Type 'a/all' to print all the maps."
      puts "Type 'q/quit' to close this program."
      puts ""
      print "> "

      input = STDIN.gets
      break if !input
      input = input.chomp.downcase

      if input == "all" || input == "a"
        n_maps.times do |i|
          puts "Drawing map #{i}"
          map = OHR::Map.new(rpg, i)
          map.draw
        end

      elsif input == "quit" || input == "q"
        break

      else
        maps = parse_input(input)
        if maps && maps.size > 0
          maps.each do |map_id|
            puts "Drawing map #{map_id}"
            map = OHR::Map.new(rpg, map_id)
            map.draw
          end
        else
          puts "Invalid input: #{input}.\n"
        end
      end
    end
  else
    puts "You must enter an rpg-file"
    puts "Usage: ruby main.rb <rpg file>"
  end
rescue Exception => e
  puts e.message
  puts e.backtrace
end

puts "\nPress Enter to continue...\n"
STDIN.gets
