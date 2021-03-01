class CreateDailySchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :daily_schedules do |t|
      t.belongs_to :meeting_rooms

      t.integer :user_id, null: false
      t.string :subject, null: false
      t.datetime :start_date, null: true
      t.datetime :end_date, null: true
      t.integer :status, null: false, default: 1

      t.timestamps
    end
  end
end
