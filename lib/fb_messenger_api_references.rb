module FbMessengerApiReferences
  class SendApi
    MESSAGE_TYPE = {
      text: :text,
      attachment: :attachment,
      quick_replies: :quick_replies,
      metadata: :metadata
    }.freeze

    MESSAGING_TYPE = {
      response: "RESPONSE",
      update: "UPDATE",
      message_tag: "MESSAGE_TAG"
    }.freeze

    SENDER_ACTION = {
      typing_on: "typing_on",
      typing_off: "typing_off",
      mark_seen: "mark_seen"
    }.freeze

    NOTFICATION_TYPE = {
      regular: "REGULAR",
      silent_push: "SILENT_PUSH",
      no_push: "NO_PUSH"
    }.freeze

    TAG = {
      confirmed_event_update: "CONFIRMED_EVENT_UPDATE",
      post_purchase_update: "POST_PURCHASE_UPDATE",
      account_update: "ACCOUNT_UPDATE"
    }.freeze

    COMMON_PARAMS = {
      messaging_type: MESSAGING_TYPE[:response],
      recipient: {
        id: nil
      },
      message: {},
      notification_type: NOTFICATION_TYPE[:regular]
    }.freeze

    PERMIT_PARAMS = {
      messaging: [:timestamp, sender: [:id], recipient: [:id], message: MESSAGE_TYPE.keys]
    }.freeze

    class << self
      def get_params_structure
        COMMON_PARAMS
      end

      def permit_params
        PERMIT_PARAMS[:messaging]
      end
    end
  end
end
