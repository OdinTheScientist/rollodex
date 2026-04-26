class CreatePositionVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :position_variants do |t|
      t.string :name, null: false
      t.text :description
      t.integer :role, null: false, default: 0
      t.references :position, null: false, foreign_key: true

      t.timestamps
    end

    add_index :position_variants, [ :position_id, :name ], unique: true
  end
end
