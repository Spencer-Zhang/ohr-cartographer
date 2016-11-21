module OHR
  class RPG

    attr_reader :path, :archinym, :rpg_name
    def initialize path
      @rpg_name = File.basename(path, File.extname(path))
      @path = File.dirname(path) + '/' + @rpg_name
      puts "RPG Path: #{@path}"
      puts "RPG Name: #{@rpg_name}"
      unlump
      @archinym = File.open("#{self.path}.rpgdir/archinym.lmp", &:readline).chomp.downcase
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
        if /cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM
          exe = "#{Dir.pwd}/unlump.exe"
        elsif File.exists?("#{Dir.pwd}/unlump")
          exe = "#{Dir.pwd}/unlump"
        elsif /darwin/ =~ RUBY_PLATFORM
          exe = "#{Dir.pwd}/unlump-mac"
        elsif /linux/ =~ RUBY_PLATFORM
          exe = "#{Dir.pwd}/unlump-linux_x86"
        else
          # Hope that unlump is in PATH
          exe = "unlump"
        end
        puts "Running #{exe} \"#{self.path}.rpg\""
        pid = spawn "#{exe}", "#{self.path}.rpg"
        Process.wait(pid)
      else
        raise "Cannot find rpg file or directory - #{self.path}.rpg"
      end
    end

  end
end
