class AddGiNogiToResources < ActiveRecord::Migration[8.1]
  def change
    add_column :resources, :gi_nogi, :integer, null: false, default: 0
    add_index  :resources, :gi_nogi
  end
end
