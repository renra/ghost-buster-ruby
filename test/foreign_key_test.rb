require 'minitest/autorun'
require_relative '../lib/foreign_key'

class ForeignKeyTest < Minitest::Test
  def test_organization_id
    subject = ForeignKey.new('organization_id')
    assert_equal subject.reference_table_name, 'organizations'
  end

  def test_child_id
    subject = ForeignKey.new('child_id')
    assert_equal subject.reference_table_name, 'children'
  end
end
