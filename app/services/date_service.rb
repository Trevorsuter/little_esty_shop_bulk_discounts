class DateService

  def get_dates
    get_url("https://date.nager.at/Api/v2/NextPublicHolidays/US?limit=3")
  end

  def closest_holidays
    get_dates[0..2].map do |data|
      Holiday.new(data)
    end
  end

  def get_url(url)
    response = Faraday.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end