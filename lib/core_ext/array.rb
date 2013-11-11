class Array
  def symbolize!
    map!{|element|
      element.is_a?(String) ? element.to_sym : element
    }
  end

  def symbolize
    self.dup.symbolize!
  end
end
