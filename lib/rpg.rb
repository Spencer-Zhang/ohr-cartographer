module OHR
  class RPG

    attr_reader :path, :archinym, :rpg_name
    def initialize path

      p 

      @path = path.split(".")[0]
      puts "RPG Path: #{@path}"
      @rpg_name = File.basename(path)
      puts "RPG Name: #{@rpg_name}"
      unlump
      @archinym = File.open("#{self.path}.rpgdir/archinym.lmp", &:readline).chomp
      puts "RPG Archinym: #{@archinym}"
    end

    def map_size
      @map_size ||= get_map_size
    end
    def get_map_size
      map_size = File.binread("#{self.path}.rpgdir/binsize.bin").unpack("v*")[4] if(File.exists? "#{self.path}.rpgdir/binsize.bin")
      map_size ||= 40
      return map_size
    end

    def unlump
      puts "Checking for RPGDIR at #{self.path}.rpgdir..."
      puts "Checking for RPG at #{self.path}.rpg..."

      if File.exists?("#{self.path}.rpgdir")
      elsif File.file?("#{self.path}.rpg")
        puts "Running #{Dir.pwd}/unlump.exe \"#{self.path}.rpg\""
        pid = spawn "#{Dir.pwd}/unlump.exe", "#{self.path}.rpg"
        Process.wait(pid)
      else
        raise "Cannot find rpg file or directory - #{self.path}.rpg"
      end
    end

  end
end
