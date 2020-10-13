class User < ApplicationRecord
  acts_as_paranoid

  USER_TYPE = {normal: 0}
  CHAT_TYPE = {chatwork: 0}

  validates :type, :ref_email, :chat_type, :ref_chat_account, presence: true
  enum type: USER_TYPE
end
