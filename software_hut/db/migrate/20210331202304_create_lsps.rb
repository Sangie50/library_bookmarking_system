class CreateLsps < ActiveRecord::Migration[6.0]
  def change
    create_table :lsps, id: false, primary_key: :registration_number do |t|
      t.integer :registration_number
      t.string :advisor_username
      t.text :disability_info
      t.text :attendance_support
      t.text :teaching_support
      t.text :presentations_support
      t.text :exams_support
      t.text :extenuating_circumstances_support
      t.date :date_shared

      t.timestamps
    end
  end
end
