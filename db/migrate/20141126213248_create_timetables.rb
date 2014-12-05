class CreateTimetables < ActiveRecord::Migration
  def change
    create_table :timetables do |t|
      t.date :closing_day

      t.references :user, index: true

      t.timestamps
    end
  end
end
