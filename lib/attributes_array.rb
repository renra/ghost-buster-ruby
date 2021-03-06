require_relative 'foreign_key'

module GhostBuster
  class AttributesArray < Array
    PK_PATTERN = /\Aid\Z/
    FK_PATTERN = ForeignKey::PATTERN

    def primary_key
      self.find_all{|el| el.match(PK_PATTERN) }.first
    end

    def foreign_keys
      self.find_all{|el| el.match(FK_PATTERN) }.map!{|el| ForeignKey.new(el) }
    end
  end
end
