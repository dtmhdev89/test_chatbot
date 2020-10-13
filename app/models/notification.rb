class Notification < ApplicationRecord
  acts_as_paranoid

  NOTI_TYPE = {daily: 0, weekly: 1, monthly: 2, yearly: 3, special: 4}

  enum schedule_type: NOTI_TYPE

  validates :schedule_type, :title_name, :creator_id, :noti_content, presence: true
end
