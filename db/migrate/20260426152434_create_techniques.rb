class CreateTechniques < ActiveRecord::Migration[8.1]
  def change
    create_table :techniques do |t|
      t.string :name, null: false
      t.text :description
      t.integer :technique_type, null: false, default: 0
      t.integer :gi_nogi, null: false, default: 0

      t.timestamps
    end

    add_index :techniques, :name, unique: true
    add_index :techniques, :technique_type
    add_index :techniques, :gi_nogi
  end
end
