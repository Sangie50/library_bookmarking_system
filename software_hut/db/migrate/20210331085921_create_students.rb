class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students, id: false, primary_key: :registration_number do |t|
      t.integer :registration_number
      t.string :title
      t.string :forename
      t.string :surname
      t.string :username
      t.string :email
      t.string :tutor_username
      t.string :department_code
      t.string :partial_programme_code
      t.date :graduation_date

      t.timestamps
    end
  end
end
