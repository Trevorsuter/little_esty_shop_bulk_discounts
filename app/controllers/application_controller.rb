class ApplicationController < ActionController::Base

  def three_closest_holidays
    @three_closest_holidays = HolidaySearch.new.holidays[0..2]
  end
  
end