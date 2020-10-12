class ChatWorkServices::ApiSearchServices
  attr_accessor :analyzed_list, :action_message, :m_action

  UNREQUESTED_TIME = {
    weather: 2,
    movie: 60
  }

  def initialize analyzed_list, options={}
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
    when :notification
      handle_notification
    else
      handle_action
    end
  end

  def handle_action
    model = m_action.to_s.classify.constantize
    last_data = model.last
    if last_data &&
      (Time.zone.now - UNREQUESTED_TIME[m_action].minutes).utc <= last_data.refresh_time.utc
      last_data.m_data
    else
      json_data = call_api
      create_data! model, json_data
      json_data
    end
  end

  def call_api
    case m_action
    when :weather
      OpenWeatherMapApi.new(type: :current).weather_forecast
    when :movie
      OpenMovieApi.new(type: :en).favourite_movies
    end
  end

  def create_data! model, json_data
    model.create!(m_data: json_data, refresh_time: Time.zone.now)
  rescue ActiveRecord::RecordInvalid
    p "something wrong when create #{m_action} data"
  end

  def handle_notification
    noti = analyzed_list&.first
    return unless noti
    ChatWorkServices::NotificationService.new(noti, options).exec_cmd
  end
end
