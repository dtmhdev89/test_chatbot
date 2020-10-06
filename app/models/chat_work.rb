class ChatWork
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Naming
  include ActiveModel::Validations::Callbacks

  ROOM_IDS = Settings.cw_room_id.chatwork.freeze
  TOKEN = ENV["CW_TOKEN"].freeze
  INPUT_PARAMS = %i(account_id room_id message_id body).freeze
  BOT_CW_ID = ENV["BOT_CW_ID"].freeze
  BODY_CHECK_REGEX = /(^\[To:#{BOT_CW_ID}\].*$)|(^\[rp aid=#{BOT_CW_ID} to=\d+-\d+\].*$)/
end
