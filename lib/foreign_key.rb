require_relative 'core_ext/string'

class ForeignKey < String
  PATTERN = /_id\Z/
  DICT = {
    :child => :children
  }

  def reference_table_name
    table_name = self.gsub(PATTERN, '')
    table_name.pluralize
  end
end
