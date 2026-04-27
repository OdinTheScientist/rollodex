class CreateResourceTechniques < ActiveRecord::Migration[8.1]
  def change
    create_table :resource_techniques do |t|
      t.references :resource, null: false, foreign_key: true
      t.references :technique, null: false, foreign_key: true

      t.timestamps
    end

    add_index :resource_techniques,
              [ :resource_id, :technique_id ],
              unique: true,
              name: "index_resource_techniques_on_resource_and_technique"
  end
end
