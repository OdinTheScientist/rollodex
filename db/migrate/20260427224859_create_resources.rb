class CreateResources < ActiveRecord::Migration[8.1]
  def change
    create_table :resources do |t|
      t.string :title, null: false
      t.string :url
      t.integer :resource_type, null: false, default: 0
      t.string :instructor_name
      t.text :notes

      t.timestamps
    end

    add_index :resources, :resource_type
    add_index :resources, :title,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "index_resources_on_title_trgm"
  end
end
