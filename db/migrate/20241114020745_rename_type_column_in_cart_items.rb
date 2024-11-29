class RenameTypeColumnInCartItems < ActiveRecord::Migration[7.1]
  def change
    rename_column :cart_items, :type, :bean_state
  end
end
