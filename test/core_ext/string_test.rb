require 'minitest/autorun'
require_relative '../../lib/core_ext/string'

class StringTest < Minitest::Test
  def test_window
    assert_equal 'window'.pluralize, 'windows'
  end

  def test_child
    assert_equal 'child'.pluralize, 'children'
  end

  def test_contacts_child
    assert_equal 'contacts_child'.pluralize, 'contacts_children'
  end
end
