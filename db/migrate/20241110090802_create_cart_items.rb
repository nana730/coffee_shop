class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.integer :quantity, null: false, default: 1
      t.references :customer, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :type, null: false

      t.timestamps
    end
  end
end
