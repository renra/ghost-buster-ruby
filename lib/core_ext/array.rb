class Array
  def symbolize!
    map!(&:to_sym)
  end
end
