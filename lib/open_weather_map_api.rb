require 'net/http'

class OpenWeatherMapApi
  CURRENT_WEATHER_QUERY = "https://api.openweathermap.org/data/2.5/weather"
  ONECALL_WEATHER_QUERY = "https://api.openweathermap.org/data/2.5/onecall"
  API_TOKEN = ENV.fetch("OPEN_WEATHER_MAP_API")
  DEFAULT_LANG = "vi"
  DEFAULT_UNIT = "metric"
  DEFAULT_MESSAGE = "Không thể lấy được thông tin thời tiết lúc này. (lay2)"

  attr_reader :type
  attr_accessor :uri, :city_name, :coordinate, :req

  def initialize options
    @options = options
    @type = @options[:type]
    build_uri
  end

  def weather_forecast
    build_req
    build_reply_message_template call_api
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

  def build_reply_message_template json_weather
    return DEFAULT_MESSAGE unless json_weather
    case type
    when :current
      current_weather_template json_weather
    when :seven_days
      seven_days_weather_template json_weather
    end
  end

  def current_weather_template json_weather
    icontxt = json_weather["weather"][0]["main"].downcase === "rain" ?  "(sad2)" : "(baibien)"
    txt = "\n[info]"
    txt << "\n#{icontxt}"
    txt << "\nĐịa điểm: #{json_weather["name"]}"
    txt << "\nThông tin thời tiết:"
    txt << "\n\tTrạng thái: #{json_weather["weather"][0]["main"]}"
    txt << "\n\tMô tả: #{json_weather["weather"][0]["description"]}"
    txt << "\n\tNhiệt độ: #{json_weather["main"]["temp"]}"
    txt << "\n\tNhiệt độ cảm nhận: #{json_weather["main"]["feels_like"]}"
    txt << "\n\tÁp suất: #{json_weather["main"]["pressure"]}"
    txt << "\n\tĐộ ẩm: #{json_weather["main"]["humidity"]}"
    txt << "\n\tTốc độ gió: #{json_weather["wind"]["speed"]}"
    txt << "\n[/info]"
  end

  def seven_days_weather_template json_weather

  end
end
