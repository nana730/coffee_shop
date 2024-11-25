class ChangeDefaultForTastesToOne < ActiveRecord::Migration[7.1]
  def change
    change_column_default :products, :acidity, 1
    change_column_default :products, :bitterness, 1
    change_column_default :products, :sweetness, 1
    change_column_default :products, :aroma, 1
    change_column_default :products, :body, 1
  end
end
