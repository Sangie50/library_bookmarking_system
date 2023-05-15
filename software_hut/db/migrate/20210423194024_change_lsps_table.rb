class ChangeLspsTable < ActiveRecord::Migration[6.0]
  def change
    change_table :lsps do |t|
      t.rename :advisor_email, :disability_advisor_email
      t.rename :attendance_support, :access_evacuation_emergency_care
      t.rename :teaching_support, :teaching
      t.rename :presentations_support, :communication_ongoing_contact
      t.rename :exams_support, :exams_and_assessment
      t.rename :extenuating_circumstances_support, :extenuating_circumstances
    end
    add_column :lsps, :disability_types, :text
    add_column :lsps, :disability_advisor_name, :text
    add_column :lsps, :practical_course_elements, :text
    add_column :lsps, :additional_recommendations, :text
  end
end
