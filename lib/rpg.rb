module OHR
  class RPG

    attr_reader :path, :archinym, :rpg_name
    def initialize path
      @path = path
      puts "RPG Path: #{@path}"
      @rpg_name = File.basename(path).split(".")[0]
      puts "RPG Name: #{@rpg_name}"
      unlump
      @archinym = File.open("#{rpg_name}.rpgdir/archinym.lmp", &:readline).chomp
      puts "RPG Archinym: #{@archinym}"
    end

    def unlump
      puts "Checking for RPGDIR at #{self.path}.rpgdir..."
      puts "Checking for RPG at #{self.path}.rpg..."

      if File.exists?("#{self.path}.rpgdir")
      elsif File.file?("#{self.path}.rpg")
        pid = spawn "unlump.exe", "#{self.path}.rpg"
        Process.wait(pid)
      else
        raise "Cannot find rpg file or directory - #{self.path}"
      end
    end

  end
end
