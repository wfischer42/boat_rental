class Dock
  attr_reader :name,
              :max_rental_time,
              :rented,
              :revenue
  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rented = {}
    @revenue = 0
  end

  def rent(boat, renter)
    if boat.class == Boat && !@rented.keys.include?(boat)
      @rented[boat] = renter
    end
  end

  def log_hour
    @rented.each {|boat, user| boat.add_hour}
  end

  def return(boat)
    hours = [boat.hours_rented, max_rental_time].min
    @revenue += hours * boat.price_per_hour
    boat.return
    @rented.delete(boat)
  end
end
