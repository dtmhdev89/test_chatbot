class Weather < ApplicationRecord
  acts_as_paranoid

  serialize :m_data, Hash

  validates :refresh_time, presence: true
end
