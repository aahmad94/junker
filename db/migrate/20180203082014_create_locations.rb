class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :address, null: false
      t.float :lat
      t.float :lon
      t.boolean :is_trash, default: false 

      t.timestamps
    end
    add_index :locations, :address, unique: true 
    add_index :locations, :lat 
    add_index :locations, :lon 
    add_index :locations, :is_trash 
  end
end
