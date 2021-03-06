class DateService

  def get_holidays
    get_url("https://date.nager.at/Api/v2/NextPublicHolidays/US")
  end

  def get_url(url)
    response = Faraday.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end