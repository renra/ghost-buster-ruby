require 'minitest/autorun'
require_relative '../../lib/core_ext/array'

class ArrayTest < Minitest::Test
  def setup
    @subject = ['one', 'two', 3]
  end

  def test_symbolize
    assert_equal @subject.symbolize, [:one, :two, 3]
    refute_equal @subject.object_id, @subject.symbolize.object_id
  end

  def test_symbolize!
    assert_equal @subject.symbolize!, [:one, :two, 3]
    assert_equal @subject.object_id, @subject.symbolize!.object_id
  end
end
