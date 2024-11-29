class RenameTypeColumnInOrderItems < ActiveRecord::Migration[7.1]
  def change
    rename_column :order_items, :type, :bean_state
  end
end
