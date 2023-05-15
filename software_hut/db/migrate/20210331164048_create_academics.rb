class CreateAcademics < ActiveRecord::Migration[6.0]
  def change
    create_table :academics do |t|
      t.string :username
      t.string :department

      t.timestamps
    end
  end
end
