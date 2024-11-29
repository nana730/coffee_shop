class Customer::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def create
    @order = current_customer.orders.build(order_params)
    @cart_items = current_customer.cart_items

    @order.postage = 500 
    @order.total_amount = @cart_items.sum(&:subtotal) + @order.postage

    if @cart_items.exists? && @order.save
      # カート内の商品を注文に追加する処理
      @cart_items.each do |cart_item|
        @order.order_items.create!(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          price: cart_item.product.price,
          bean_state: CartItem.bean_states[cart_item.bean_state],
        )

         # 在庫数を減らす処理
      product = cart_item.product
      if product.stock >= cart_item.quantity
        product.update!(stock: product.stock - cart_item.quantity)
      else
        flash[:alert] = "#{product.name}の在庫が足りません。"
        redirect_to cart_items_path and return
      end
    end
      # カートを空にする
      @cart_items.destroy_all
      redirect_to order_path(@order), notice: '注文が完了しました。オーナーの確認をお待ちください。'
    else
      flash[:alert] = "注文に失敗しました"
      @total_price = @cart_items.sum(&:subtotal)
      @postage = 500
      render 'customer/cart_items/index', status: :unprocessable_entity
    end
  end

  def show
    @order = current_customer.orders.eager_load(order_items: :product).find(params[:id])
  end
  
  def index
    @orders = current_customer.orders
                              .eager_load(order_items: :product)  # eager_loadで関連データを結合
                              .latest
  end

  private

  def order_params
    params.require(:order).permit(:name, :postal_code, :prefecture, :address, :status)
  end
end
