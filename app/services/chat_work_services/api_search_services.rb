class ChatWorkServices::ApiSearchServices
  attr_accessor :analyzed_list, :action_message, :m_action

  def initialize analyzed_list
    @analyzed_list = analyzed_list
    @action_message = CommonKeyWordApiSearch::Messages.new
  end

  def search
    [get_action_for_analyzed_list, get_inner_type_for_action, get_data_for_action]
  end

  private

  def get_action_for_analyzed_list
    @m_action = "";
    analyzed_list.dup.map do |searchObj|
      @m_action = action_message.send(searchObj[:key].to_sym, searchObj[:str])
      break if @m_action
    end
    @m_action
  end

  def get_inner_type_for_action
    case m_action
    when :hello
      :hello
    when :weather
      :current
    when :movie
      :en
    end
  end

  def get_data_for_action
    case m_action
    when :hello
      :hello
    when :weather
      OpenWeatherMapApi.new(type: :current).weather_forecast
    when :movie
      OpenMovieApi.new(type: :en).favourite_movies
    end
  end
end
