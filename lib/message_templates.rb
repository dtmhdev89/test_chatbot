module MessageTemplates
  class ChatWork
    DEFAULT_MESSAGES = {
      weather: "Không thể lấy được thông tin thời tiết lúc này. (lay2)",
      movie: "(lay2) \n Không tìm thấy phim thím ơi!",
      action_not_found: "(hucau4)\n Bị lỗi gì ấy nhỉ? :v"
    }

    ICONS = {
      clear_sky: "(baibien)",
      few_clouds: "(nghichnuoc)",
      scattered_clouds: "(tam)",
      broken_clouds: "(chemgio)",
      shower_rain: "(sad2)",
      rain: "(rain2)",
      thunderstorm: "(shit)",
      snow: "(retqua)",
      mist: "(sleep)"
    }

    class << self
      def hello inner_type="", json_data={}
        ["chào bạn", "yeap, boom!! (quaylen)", "(hi)", "hi! my sugar baby!"].sample
      end

      def weather inner_type="", json_weather={}
        return default_message action if inner_type.empty? || json_weather.blank?

        case inner_type
        when :current
          current_weather_template json_weather
        when :seven_days
          seven_days_weather_template json_weather
        end
      end

      def movie inner_type="", json_movie={}
        return default_message action if inner_type.empty? || json_movie.blank?

        case inner_type
        when :vi
        when :en
          movie_en json_movie
        end
      end

      def default_message action
        DEFAULT_MESSAGES.dig(action.to_sym)
      end

      private

      def current_weather_template json_weather
        icontxt = ICONS[json_weather["weather"][0]["main"].downcase.sub(/\s/, "_").to_sym] || "(baibien)"
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

      def movie_vi
      end

      def movie_en json_movie
        movie_data = json_movie["data"]["fanPicksTitles"]["edges"]
        icontxt = "(ok)"
        txt = "\n[info]"
        txt << "\n#{icontxt}"
        txt << "\nList IMDB's Fan Favourite Movies:"
        movie_data.sample(7).each do |movie|
          txt << "\n\t~O) Phim: #{movie['node']['titleText']['text']}"
          txt << "\n\t\tNăm sản xuất: #{movie['node']['releaseYear']['year']}"
          txt << "\n\t\tRaing: #{movie['node']['ratingsSummary']['aggregateRating']}"
          txt << "\n\t\tRaing Count: #{movie['node']['ratingsSummary']['voteCount']}"
        end
        txt << "\n[/info]"
      end
    end
  end
end
