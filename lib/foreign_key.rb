class ForeignKey < String
  PATTERN = /_id\Z/

  def reference_table_name
    (self.gsub(PATTERN, '') << 's').to_sym
  end
end
