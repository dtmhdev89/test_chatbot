class FbsWebhooksController < ApplicationController
  require 'net/http'

  before_action :load_get_data, only: :fbs_webhook, if: ->{request.get?}
  before_action :load_post_data, only: :fbs_webhook, if: ->{request.post?}

  def fbs_webhook
    respond_to do |format|
      format.json do
        return verify_webhook if request.get?
        return handle_event if request.post?
      end
    end
  end

  private

  def verify_webhook
    return render json: {status: :failed}, status: 403 if !valid_condition

    render plain: @challenge.to_s, status: :ok
  end

  def handle_event
    p "============ handle event"
    return render json: {status: :not_found}, status: :not_found if !(@object === FbsMessenger::VERIFY_OBJECT)

    p "============================ handle response fb messenger data"
    p "==================#{@entries["messaging"][0].as_json}"
    HandleResponseFbMessengerJob.perform_later @entries["messaging"][0].as_json
    p "============================ enqueued fb reponse job"

    render plain: nil, status: 200
  end

  def valid_condition
    @mode && @token && @mode === FbsMessenger::VERIFY_MODE && @token === FbsMessenger::VERIFY_TOKEN
  end

  def load_get_data
    @mode = params['hub.mode']
    @token = params['hub.verify_token']
    @challenge = params['hub.challenge']
  end

  def load_post_data
    @object = params["object"]
    @entries = params["entry"][0]
  end

  def messaging_permit_params
    FbMessengerApiReferences::SendApi.permit_params
  end
end
