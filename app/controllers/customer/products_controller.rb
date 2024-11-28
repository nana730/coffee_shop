class Customer::ProductsController < ApplicationController
  def index
    @products, @sort = get_products(params)
    # すでに取得された@productsに対してEager Loadingを適用
    @products = @products.includes(image_attachment: :blob)
  end
  
  def show
    @product = Product.find(params[:id])
    @cart_item = CartItem.new
  end

  private

  def get_products(params)
    # 特定の並び順が選択されていない場合は全ての製品を返す
    return Product.all, 'default' unless params[:latest] || params[:price_high_to_low] || params[:price_low_to_high] || params[:taste_sort]

    # 最新順の並び替え
    return Product.latest, 'latest' if params[:latest]

    # 価格順（高い順）
    return Product.price_high_to_low, 'price_high_to_low' if params[:price_high_to_low]

    # 価格順（低い順）
    return Product.price_low_to_high, 'price_low_to_high' if params[:price_low_to_high]

    # 味わいの並び替え
    if params[:taste_sort].in?(['acidity', 'bitterness', 'sweetness', 'aroma', 'body'])
      return Product.taste_sort(params[:taste_sort]), params[:taste_sort]
    end

    # デフォルト値を返す
    [Product.all, 'default']
  end
end

