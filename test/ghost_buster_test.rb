require 'minitest/autorun'

class GhostBusterTest < Minitest::Test
  def setup
    puts "Setting up"
  end

  def test_true
    assert_equal true, true
  end
end
