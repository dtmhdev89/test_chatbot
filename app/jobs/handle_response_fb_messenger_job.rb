class HandleResponseFbMessengerJob < ApplicationJob
  require 'net/http'

  queue_as :high_prio

  def perform params={}
    p "================ do job ::::: #{params}"
    return handle_other params if check_required_params(params).any?(false)

    user = User.find_or_create_by! ref_chat_account: params.dig("sender", "id")
    Adapter::FbsAdapter.new(params).send_reply_message
  end

  def check_required_params params
    ["sender", "message"].map{|key| params[key].present?}
  end

  def handle_other params
    return if ["read"].map{|key| params[key].present?}.any?(false)

    #send response in responding
    Adapter::FbsAdapter.new(params).send_action_state
  end
end
