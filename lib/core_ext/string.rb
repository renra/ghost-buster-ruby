class String
  DICT = {
    'child' => 'children'
  }

  def pluralize
    DICT[self] || (self + 's')
  end
end
