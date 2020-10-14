class Notification < ApplicationRecord
  acts_as_paranoid

  NOTI_TYPE = {daily: 0, weekly: 1, monthly: 2, yearly: 3, oneday: 4, special: 5}

  serialize :scheduled_at, Array
  enum schedule_type: NOTI_TYPE

  belongs_to :user, foreign_key: :creator_id

  validates :schedule_type, :title_name, :creator_id, :noti_content, presence: true
  validates :title_name, uniqueness: {scope: :creator_id}
end
