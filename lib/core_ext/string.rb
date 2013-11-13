class String
  DICT = {
    /child\z/ => 'ren'
  }

  def pluralize
    DICT.each do |pattern, suffix|
      if self.match(pattern)
        return (self + suffix)
      end
    end

    (self + 's')
  end
end
