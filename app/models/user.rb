class User < ApplicationRecord
  acts_as_paranoid

  USER_TYPE = {normal: 0}
  CHAT_TYPE = {chatwork: 0}

  enum user_type: USER_TYPE
  enum chat_type: CHAT_TYPE

  has_many :notifications, foreign_key: :creator_id

  validates :user_type, :ref_email, :chat_type, :ref_chat_account, presence: true
  validates :ref_chat_account, uniqueness: {scope: [:ref_email, :chat_type]}
end
