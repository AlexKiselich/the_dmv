class Facility
  attr_reader :name, 
              :address, 
              :phone, 
              :services,
              :registered_vehicles,
              :collected_fees

  def initialize(facility_details)
    @name = facility_details[:name]
    @address = facility_details[:address]
    @phone = facility_details[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle)
    if services.include?('Vehicle Registration')
      vehicle.registration_date = Date.today
      @registered_vehicles << vehicle
        if vehicle.plate_type == :antique
          @collected_fees += 25
          elsif vehicle.plate_type == :ev
            @collected_fees += 200
          elsif vehicle.plate_type == :regular
            @collected_fees += 100
        end
        
    end
  end


end
