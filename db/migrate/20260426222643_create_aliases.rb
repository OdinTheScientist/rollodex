class CreateAliases < ActiveRecord::Migration[8.1]
  def change
    create_table :aliases do |t|
      t.string :name, null: false
      t.references :aliasable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :aliases, :name
    add_index :aliases, [ :aliasable_type, :aliasable_id ]
  end
end
