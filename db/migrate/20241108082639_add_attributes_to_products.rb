class AddAttributesToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :acidity, :integer, default: 0
    add_column :products, :bitterness, :integer, default: 0
    add_column :products, :sweetness, :integer, default: 0
    add_column :products, :aroma, :integer, default: 0
    add_column :products, :body, :integer, default: 0
  end
end
