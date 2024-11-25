class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :name, null: false
      t.string :postal_code, null: false
      t.string :prefecture, null: false
      t.string :address, null: false
      t.integer :postage, null: false
      t.integer :total_amount, null: false
      t.integer :status, null: false
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
