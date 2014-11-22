module OHR
  class RPG

    attr_reader :filename, :archinym, :rpg_name
    def initialize rpg_name
      @filename = rpg_name
      @rpg_name = File.basename(rpg_name)
      unlump
      @archinym = File.open("#{rpg_name}.rpgdir/archinym.lmp", &:readline).chomp
    end

    def unlump
      if File.exists?("#{self.filename}.rpgdir")
      elsif File.file?("#{self.filename}.rpg")
        pid = spawn "unlump \"#{self.filename}.rpg\""
        Process.wait(pid)
      else
        raise "Cannot find rpg file or directory - #{self.filename}"
      end
    end

  end
end
