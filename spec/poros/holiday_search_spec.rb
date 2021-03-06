require 'rails_helper'

RSpec.describe HolidaySearch do
  before :each do
    @holiday_search = HolidaySearch.new
  end

  it 'possesses a service' do
    expect(@holiday_search.service.class).to eq(DateService)
  end

  it 'has holidays' do
    @holiday_search.holidays.each do |holiday|
      expect(holiday.class).to eq(Holiday)
    end
  end

end