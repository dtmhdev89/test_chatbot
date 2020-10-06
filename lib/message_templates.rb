module MessageTemplates
  class ChatWork
    class << self
      def hello type="", json_data={}
        ["chào bạn", "yeap, boom!! (quaylen)", "(hi)"].sample
      end

      def weather type, json_weather
        case type
        when :current
          current_weather_template json_weather
        when :seven_days
          seven_days_weather_template json_weather
        end
      end

      private

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
  end
end
