class AddTrgmIndexesToTechniques < ActiveRecord::Migration[8.1]
  def change
    add_index :techniques, :name,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "index_techniques_on_name_trgm"

    add_index :positions, :name,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "index_positions_on_name_trgm"
  end
end
