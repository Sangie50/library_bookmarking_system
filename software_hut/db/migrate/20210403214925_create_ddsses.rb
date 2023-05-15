class CreateDdsses < ActiveRecord::Migration[6.0]
  def change
    create_table :ddsses do |t|

      t.timestamps
    end
  end
end
