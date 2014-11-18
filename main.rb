require_relative 'mapper.rb'

if(ARGV[0])
  rpg_name = ARGV[0].split(".")[0]

  if File.exists?("#{rpg_name}.rpgdir")

  elsif File.file?("#{rpg_name}.rpg")
    exec "unlump.exe #{rpg_name}.rpg"
  else
    raise "Cannot find rpg file or directory"
  end

  Mapper.draw_map(rpg_name, 0)

end