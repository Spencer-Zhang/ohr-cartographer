module OHR
  class RPG

    attr_reader :filename, :archinym
    def initialize rpg_name
      @filename = rpg_name
      @archinym = File.open("#{rpg_name}.rpgdir/archinym.lmp", &:readline).chomp
      unlump
    end

    def unlump
      if File.exists?("#{self.filename}.rpgdir")
      elsif File.file?("#{self.filename}.rpg")
        exec "unlump.exe #{self.filename}.rpg"
      else
        raise "Cannot find rpg file or directory"
      end
    end

  end
end