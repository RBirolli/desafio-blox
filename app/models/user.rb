class User < ApplicationRecord

  has_many :meeting_rooms

	validates :name, uniqueness: true
end
