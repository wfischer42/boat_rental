require 'minitest/autorun'
require 'minitest/pride'
require './lib/dock'
require './lib/boat'
require './lib/renter'

require 'pry'

class DockTest < Minitest::Test
  def setup
    @dock = Dock.new("The Rowing Dock", 3)

    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @canoe = Boat.new(:canoe, 25)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @sup_2 = Boat.new(:standup_paddle_board, 15)

    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  def test_it_exists
    assert_instance_of Dock, @dock
  end

  def test_it_has_name_max_rental_time_and_zero_revenue_by_default
    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
    assert_equal 0, @dock.revenue
  end

  def test_boats_can_be_rented
    @dock.rent(@sup_1, @patrick)
    @dock.rent(@canoe, @eugene)

    expected = {@sup_1 => @patrick, @canoe => @eugene}
    assert_equal expected, @dock.rented
  end

  def test_people_etc_cannot_be_rented
    @dock.rent(@patrick, @eugine)
    @dock.rent("This string is not a boat", @patrick)
    expected = {}
    assert_equal expected, @dock.rented
  end

  def test_boats_cannot_be_double_booked
    @dock.rent(@sup_1, @patrick)
    @dock.rent(@sup_1, @eugine)

    expected = {@sup_1 => @patrick}
    assert_equal expected, @dock.rented
  end

  def test_logged_hours_are_passed_to_boats

    @dock.rent(@kayak_1, @patrick)
    @dock.log_hour
    @dock.rent(@sup_2, @eugine)
    @dock.log_hour

    assert_equal 1, @sup_2.hours_rented
    assert_equal 2, @kayak_1.hours_rented
  end

  def test_boats_can_be_returned
    @dock.rent(@kayak_1, @patrick)
    @dock.log_hour
    @dock.return(@kayak_1)

    expected = {}
    assert_equal expected, @dock.rented
  end

  def test_it_collects_revenue_after_return
    @dock.rent(@kayak_1, @patrick)
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.return(@kayak_1)

    assert_equal 60, @dock.revenue
  end

  def test_it_stops_adding_revenue_after_3_hours
    @dock.rent(@kayak_1, @patrick)
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.log_hour
    @dock.return(@kayak_1)

    assert_equal 60, @dock.revenue
  end

  def test_it_resets_boats_rented_hours_after_return
    @dock.rent(@kayak_1, @patrick)
    @dock.log_hour
    @dock.return(@kayak_1)

    assert_equal 0, @kayak_1.hours_rented
  end
end
