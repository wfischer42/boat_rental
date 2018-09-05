require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'

class BoatTest < Minitest::Test
  def setup
    @boat = Boat.new(:kayak, 20)
  end

  def test_it_exists
    assert_instance_of Boat, @boat
  end

  def test_it_has_attributes
    assert_equal :kayak, @boat.type
    assert_equal 20, @boat.price_per_hour
  end

  def test_it_has_zero_rented_hours_by_default
    assert_equal 0, @boat.hours_rented
  end

  def test_it_can_be_rented_by_the_hour
    @boat.add_hour
    @boat.add_hour
    assert_equal 2, @boat.hours_rented
  end
end
