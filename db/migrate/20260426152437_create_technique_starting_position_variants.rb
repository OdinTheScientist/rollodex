class CreateTechniqueStartingPositionVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :technique_starting_position_variants do |t|
      t.references :technique, null: false, foreign_key: true
      t.references :position_variant, null: false, foreign_key: true

      t.timestamps
    end

    add_index :technique_starting_position_variants,
              [ :technique_id, :position_variant_id ],
              unique: true,
              name: "index_starting_variants_on_technique_and_position_variant"
  end
end
