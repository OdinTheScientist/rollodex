class CreateResourcePositions < ActiveRecord::Migration[8.1]
  def change
    create_table :resource_positions do |t|
      t.references :resource, null: false, foreign_key: true
      t.references :position, null: false, foreign_key: true

      t.timestamps
    end

    add_index :resource_positions,
              [ :resource_id, :position_id ],
              unique: true,
              name: "index_resource_positions_on_resource_and_position"
  end
end
