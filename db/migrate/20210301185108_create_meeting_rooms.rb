class CreateMeetingRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :meeting_rooms do |t|
      t.belongs_to :user

      t.string :name, null: false
      t.string :local, null: false

      t.timestamps
    end
  end
end
