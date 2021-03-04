class DailySchedule < ApplicationRecord

  belongs_to :meeting_room

	validates :user_id, :subject, :status, :start_date, :end_date, presence: true

end
