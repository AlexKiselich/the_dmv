require 'spec_helper'

RSpec.describe DMVFacility do
  it 'exists' do
    
    dmv_factory = DMVFacility.new

    expect(dmv_factory).to be_a DMVFacility
  end

  it 'can create facilities from APIs' do
    dmv_factory = DMVFacility.new

    dmv_data = DmvDataService.new.or_dmv_office_locations
    dmv_factory.create_dmv_facilities(dmv_data)

    expect(dmv_factory.list_of_Facilities[0]).to be_a Facility

  end

  it 'can create ny facilities' do
    dmv_factory = DMVFacility.new

    ny_dmv_data = DmvDataService.new.ny_dmv_office_locations

    dmv_factory.create_ny_dmv_office_locations(ny_dmv_data)

    expect(dmv_factory.list_of_NY_Facilities[2]).to be_a Facility
  end

  it 'can create mo facilities' do
    dmv_factory = DMVFacility.new

    mo_dmv_data = DmvDataService.new.mo_dmv_office_locations

    dmv_factory.create_mo_dmv_office_locations(mo_dmv_data)

    expect(dmv_factory.list_of_MO_Facilities[3]).to be_a Facility
  end

end
