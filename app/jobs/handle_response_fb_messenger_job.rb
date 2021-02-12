class HandleResponseFbMessengerJob < ApplicationJob
  require 'net/http'

  queue_as :high_prio

  def perform params={}
    p "================ do job ::::: #{params}"
    return if check_required_params(params).any?(false)
    user = User.find_or_create_by! ref_chat_account: params.dig("sender", "id")

    json_response = FbsMessenger.get_response_template params
    uri = URI("https://graph.facebook.com/v9.0/me/messages?access_token=#{ENV['FBS_ACCESS_TOKEN']}")
    req = Net::HTTP::Post.new(uri)
    req['content-type'] = "application/json"
    req.body = json_response.to_json
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

  def check_required_params params
    ["sender", "message"].map{|key| params[key].present?}
  end
end
