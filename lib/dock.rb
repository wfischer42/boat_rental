class Dock
  attr_reader :name,
              :max_rental_time,
              :rented,
              :revenue,
              :charges,
              :rental_data
  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rented = {}
    @revenue = 0
    @charges = Hash.new(0)
    @rental_data = []
  end

  def rent(boat, renter)
    if valid_boat?(boat) && valid_renter?(renter)
      @rented[boat] = renter
    end
  end

  def valid_boat?(boat)
    boat.class == Boat && !@rented.keys.include?(boat)
  end

  def valid_renter?(renter)
    renter.class == Renter
  end

  def log_hour
    @rented.each {|boat, user| boat.add_hour}
  end

  def return(boat)
    rental_cost = record_revenue(boat)
    record_rental_data(boat, rental_cost)
    @rented.delete(boat)
    boat.return
  end

  def record_revenue(boat)
    hours = [boat.hours_rented, max_rental_time].min
    rental_cost = hours * boat.price_per_hour
    card = @rented[boat].credit_card_number
    @charges[card] += rental_cost
    @revenue += rental_cost
    return rental_cost
  end

  def record_rental_data(boat, rental_cost)
    entry = {type: boat.type,
             hours: boat.hours_rented,
             revenue: rental_cost,
             renter: @rented[boat]}
    @rental_data << entry
  end

  def total_hours_by_rental_type
    hours_by_type = Hash.new(0)
    @rental_data.each do |type_data|
      type = type_data[:type]
      hours_by_type[type] += type_data[:hours]
    end
    return hours_by_type
  end
end
