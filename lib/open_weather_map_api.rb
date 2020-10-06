require 'net/http'

class OpenWeatherMapApi
  CURRENT_WEATHER_QUERY = "https://api.openweathermap.org/data/2.5/weather"
  ONECALL_WEATHER_QUERY = "https://api.openweathermap.org/data/2.5/onecall"
  API_TOKEN = ENV.fetch("OPEN_WEATHER_MAP_API")
  DEFAULT_LANG = "vi"
  DEFAULT_UNIT = "metric"

  attr_reader :type
  attr_accessor :uri, :city_name, :coordinate, :req

  def initialize options
    @type = options[:type]
    build_uri
  end

  def weather_forecast
    build_req
    call_api
  end

  private

  def build_uri
    case type
    when :current
      get_city_name
      query = "?q=#{city_name}&APPID=#{API_TOKEN}" << default_option
      @uri = URI(CURRENT_WEATHER_QUERY << query)
    when :seven_days
      get_coordinate
      query = "?lat=#{coordinate[:lat]}&lon=#{coordinate[:lon]}&exclude=alerts&APPID=#{API_TOKEN}" << default_option
      @uri = URI(ONECALL_WEATHER_QUERY << query)
    end
  end

  def get_city_name
    @city_name = "Danang"
  end

  def get_coordinate
    @coordinate = {
      lat: 16.07,
      lon: 108.22
    }
  end

  def build_req
    @req = Net::HTTP::Get.new(uri)
  end

  def default_option
    "&lang=#{DEFAULT_LANG}&units=#{DEFAULT_UNIT}"
  end

  def call_api
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
      http.request(req)
    end

    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      JSON.parse res.body
    else
      p "something wrong"
      nil
    end
  end

  def seven_days_weather_template json_weather

  end
end
