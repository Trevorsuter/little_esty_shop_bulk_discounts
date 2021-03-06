class HolidaySearch

  def service
    DateService.new
  end

  def holidays
    service.get_holidays.map do |data|
      Holiday.new(data)
    end
  end
end