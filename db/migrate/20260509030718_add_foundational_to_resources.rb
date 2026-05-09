class AddFoundationalToResources < ActiveRecord::Migration[8.1]
  def change
    add_column :resources, :foundational, :boolean, null: false, default: false
  end
end
