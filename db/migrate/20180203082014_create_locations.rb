class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.float :lat, null: false 
      t.float :lon, null: false 
      t.boolean :is_trash, default: false 

      t.timestamps
    end
    add_index :locations, [:lat, :lon], unique: true 
    add_index :locations, :is_trash 
  end
end
