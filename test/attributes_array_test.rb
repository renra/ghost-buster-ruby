require 'minitest/autorun'
require_relative '../lib/attributes_array'

class AttributesArrayTest < Minitest::Test
  def setup
    @subject = AttributesArray.new(
      [
        'time',
        'id',
        'organization_id',
        'child_id'
      ]
    )
  end

  def test_primary_key
    assert_equal @subject.primary_key, 'id'
  end

  def test_foreign_keys
    assert_equal @subject.foreign_keys, ['organization_id', 'child_id']
  end
end
