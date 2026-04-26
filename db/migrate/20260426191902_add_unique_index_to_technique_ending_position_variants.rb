class AddUniqueIndexToTechniqueEndingPositionVariants < ActiveRecord::Migration[8.1]
  def change
    add_index :technique_ending_position_variants,
              [ :technique_id, :position_variant_id ],
              unique: true,
              name: "index_ending_variants_on_technique_and_position_variant"
  end
end
