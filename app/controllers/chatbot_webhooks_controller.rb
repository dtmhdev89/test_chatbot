class ChatbotWebhooksController < ApplicationController
  require 'net/http'

  before_action :signature_verification

  def cw_hook
    respond_to do |format|
      format.json { send_reply_message }
      format.html { send_reply_message }
    end
  end

  private
  def set_params input_params
    params.require(:webhook_event).permit(input_params)
  end

  def send_reply_message
    Adapter::ChatWorkAdapter.new(message_params: set_params(ChatWork::INPUT_PARAMS), verification: @verification)
      .send_reply_message
  end

  def signature_verification
    @verification = Adapter::ChatWorkAdapter.signature_verification request.headers, request.body.read
  end
end
