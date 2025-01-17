require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility).to be_an_instance_of(Facility)
      expect(@facility.name).to eq('Albany DMV Office')
      expect(@facility.address).to eq('2242 Santiam Hwy SE Albany OR 97321')
      expect(@facility.phone).to eq('541-967-2014')
      expect(@facility.services).to eq([])
      expect(@facility.registered_vehicles).to eq([])
      expect(@facility.collected_fees).to eq(0)
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility.services).to eq([])
      @facility.add_service('New Drivers License')
      @facility.add_service('Renew Drivers License')
      @facility.add_service('Vehicle Registration')
      expect(@facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end
end

RSpec.describe Facility do
  before(:each) do
    @facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    @facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })

    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
  end
  
  describe '#register_vehicle' do
    it 'can register a vehicle' do
      @facility_1.add_service('Vehicle Registration')
      expect(@cruz.registration_date).to eq(nil)
      expect(@facility_1.registered_vehicles).to eq([])
      expect(@facility_1.collected_fees).to eq(0)

      @facility_1.register_vehicle(@cruz)
      expect(@facility_1.registered_vehicles).to eq([@cruz])
      expect(@cruz.registration_date).to eq(Date.today)
      expect(@cruz.plate_type).to eq(:regular)
    end
  end
  
  describe '#collected_fees' do
    it 'can collect fees' do
      @facility_1.add_service('Vehicle Registration')
      @facility_1.register_vehicle(@cruz)
      expect(@facility_1.collected_fees).to eq(100)
    end
  end


  describe 'multiple vehicles test' do
    it 'can register and collect fees fot multiple vehicles' do
      
      @facility_1.add_service('Vehicle Registration')
      @facility_1.register_vehicle(@cruz)
      @facility_1.register_vehicle(@camaro)
      
      expect(@facility_1.registered_vehicles).to eq([@cruz, @camaro])
      
      @facility_1.register_vehicle(@bolt)
      expect(@facility_1.collected_fees).to eq(325)
    end
  end
  
  describe "can't register vehicle" do
    it 'will not register vehicle if not offered at facility' do
      expect(@facility_2.registered_vehicles).to eq([])
      expect(@facility_2.services).to eq([])
      
      @facility_2.register_vehicle(@bolt)
      
      
      expect(@facility_2.registered_vehicles).to eq([])
      expect(@facility_2.collected_fees).to eq(0)

    end
  end
end



RSpec.describe Facility do
  before(:each) do
    @registrant_1 = Registrant.new('Bruce', 18, true )
    @registrant_2 = Registrant.new('Penny', 16 )
    @registrant_3 = Registrant.new('Tucker', 15 )

    @facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    @facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })
  end

  # Written Test

  describe '#administer_written_test' do
    it 'can give a written test' do
      
      expect(@facility_1.administer_written_test(@registrant_1)).to eq(false)

      @facility_1.add_service('Written Test')

      expect(@facility_1.administer_written_test(@registrant_1)).to eq(true)
      expect(@facility_1.administer_written_test(@registrant_2)).to eq(false)

      @registrant_2.earn_permit
      expect(@facility_1.administer_written_test(@registrant_2)).to eq(true)
    end
  end

  describe '#administer road test' do
    it 'can give a road test' do

      expect(@facility_1.administer_raod_test(@registrant_1)).to eq(false)

      @facility_1.add_service('Written Test')
      expect(@facility_1.administer_raod_test(@registrant_1)).to eq(false)

      @facility_1.add_service('Road Test')
      expect(@facility_1.administer_raod_test(@registrant_1)).to eq(false)

      @facility_1.administer_written_test(@registrant_1)
      expect(@facility_1.administer_raod_test(@registrant_1)).to eq(true)
    end
  end


  describe '#renew_drivers_license' do
    it 'can renew a drivers license' do

      expect(@facility_1.renew_drivers_license(@registrant_1)).to eq(false)

      @facility_1.add_service('Written Test')
      @facility_1.add_service('Road Test')
      expect(@facility_1.renew_drivers_license(@registrant_1)).to eq(false)

      @facility_1.add_service('Renew License')
      @facility_1.administer_written_test(@registrant_1)
      @facility_1.administer_raod_test(@registrant_1)
      expect(@facility_1.renew_drivers_license(@registrant_1)).to eq(true)
    end
  end

  describe 'mulitple registrants test' do
    it 'can run with multiple registrants' do

      expect(@facility_1.services).to eq([])

      @facility_1.add_service('Written Test')
      @facility_1.add_service('Road Test')
      @facility_1.add_service('Renew License')
      @facility_1.administer_written_test(@registrant_1)
      expect(@facility_1.administer_written_test(@registrant_2)).to eq(false)

      @registrant_2.earn_permit
      @facility_1.administer_written_test(@registrant_2)
      @facility_1.administer_raod_test(@registrant_1)
      @facility_1.renew_drivers_license(@registrant_1)
      expect(@facility_1.renew_drivers_license(@registrant_2)).to eq(false)

      @facility_1.administer_raod_test(@registrant_2)
      expect(@facility_1.renew_drivers_license(@registrant_2)).to eq(true)
    end
  end



end
