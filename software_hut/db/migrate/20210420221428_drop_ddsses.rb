class DropDdsses < ActiveRecord::Migration[6.0]
  def change
    drop_table :ddsses do |t|
      t.timestamps
    end
  end
end
