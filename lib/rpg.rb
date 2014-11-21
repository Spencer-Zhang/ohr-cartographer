module OHR
  class RPG

    attr_reader :filename, :archinym
    def initialize rpg_name
      @filename = rpg_name
      unlump
      @archinym = File.open("#{rpg_name}.rpgdir/archinym.lmp", &:readline).chomp
    end

    def unlump
      if File.exists?("#{self.filename}.rpgdir")
      elsif File.file?("#{self.filename}.rpg")
        pid = spawn "unlump.exe \"#{self.filename}.rpg\""
        Process.wait(pid)
      else
        raise "Cannot find rpg file or directory"
      end
    end

  end
end
