class MeetingRoom < ApplicationRecord

  belongs_to :user
  has_many :daily_schedules, dependent: :destroy

	validates :name, uniqueness: true, presence: true
	validates :user_id, :local, :status, presence: true

end
