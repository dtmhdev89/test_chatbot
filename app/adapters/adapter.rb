module Adapter
  class ChatWorkAdapter
    attr_reader :message_params, :body, :verification
    attr_accessor :sent_message, :uri, :req

    def initialize args
      @verification = args[:verification]
      @message_params = args[:message_params]
      @body = @message_params[:body]
    end

    def send_reply_message
      return unless check_validations

      if verification
        analyzed_list = ChatWorkServices::AnalyzeSearchWordsServices.new(body).analyze
        message_action, inner_type, json_data = ChatWorkServices::ApiSearchServices.new(analyzed_list, account_id: message_params[:account_id].to_s).search
      else
        message_action = :invalid
      end

      #send message to chatwork
      build_uri
      build_sent_message message_action, inner_type, json_data
      build_req

      res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
        http.request(req)
      end

      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        p "OK"
      else
        p "something wrong"
      end
    end

    class << self
      def signature_verification req_headers, req_body
        chw_sign = req_headers.fetch("X-ChatWorkWebhookSignature", "")
        signature = OpenSSL::HMAC.digest("SHA256", Base64.decode64(ENV.fetch("SIGN_SECRET_KEY", "")), req_body)
        expected_sign = Base64.strict_encode64(signature)
        chw_sign == expected_sign
      end
    end

    private

    def check_validations
      return invalid if message_params[:account_id].to_s === ChatWork::BOT_CW_ID
      return invalid unless message_params[:room_id].in?(ChatWork::ROOM_IDS)
      return invalid unless body.match?(ChatWork::BODY_CHECK_REGEX)
      true
    end

    def invalid
      false
    end

    def build_uri
      @uri = URI("https://api.chatwork.com/v2/rooms/#{message_params[:room_id]}/messages")
    end

    def build_sent_message message_action, inner_type, json_data
      rb_message = ReplyMessagePresenter.new(
        {adapter_type: :chatwork, message_type: message_action, inner_type: inner_type},
        json_data).get_message

      @sent_message = "[rp aid=#{message_params[:account_id]}" +
        " to=#{message_params[:room_id]}-#{message_params[:message_id]}]\n#{rb_message}"
    end

    def build_req
      @req = Net::HTTP::Post.new(uri)
      @req['X-ChatWorkToken'] = ChatWork::TOKEN
      @req.set_form_data('body' => sent_message, 'self_unread' => '0')
    end

    def invalid_message
      MessageTemplates::ChatWork.default_message :not_authorized
    end

  end

  class OtherChatAppAdapter

  end
end
