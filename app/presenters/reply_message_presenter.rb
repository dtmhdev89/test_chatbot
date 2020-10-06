class ReplyMessagePresenter
  attr_reader :adapter_type, :message_type, :json_data, :inner_type

  def initialize options, json_data
    @options = options
    @adapter_type = options[:adapter_type]
    @message_type = options[:message_type]
    @inner_type = options[:inner_type]
    @json_data = json_data
  end

  def get_message
    case adapter_type
    when :chatwork
      chatwork_message
    end
  end

  private

  def chatwork_message
    MessageTemplates::ChatWork.send(message_type, inner_type, json_data})
  end
end
