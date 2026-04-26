class CreatePositions < ActiveRecord::Migration[8.0]
  def change
    create_table :positions do |t|
      t.string :name, null: false
      t.text :description
      t.integer :category, null: false, default: 0

      t.timestamps
    end

    add_index :positions, :name, unique: true
    add_index :positions, :category
  end
end
