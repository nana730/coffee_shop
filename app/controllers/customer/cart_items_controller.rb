class Customer::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_cart_item, only: %i[destroy update]
  before_action :set_cart_items_and_total_price, only: %i[index update create]

  def index
    @cart_items = current_customer.cart_items.includes(:product).order(:created_at)
    @order = current_customer.orders.build # 注文のインスタンスを作成
    @total_price = @cart_items.sum(&:subtotal) # subtotalにアクセスするときもN+1を防げる
  end

  def create
    product_id = params[:cart_item][:product_id]
    bean_state = params[:cart_item][:bean_state]
    quantity = params[:cart_item][:quantity].to_i
  
    # 商品の存在チェック
    unless Product.exists?(product_id)
      redirect_to cart_items_path, alert: '選択された商品が存在しません。' and return
    end
  
    # カートアイテムを検索または新規作成
    @cart_item = current_customer.cart_items.find_by(product_id: product_id, bean_state: CartItem.bean_states[bean_state])
  
    if @cart_item
      # 既存のアイテムが見つかった場合、数量を更新
      @cart_item.quantity += quantity
      message = 'カートの数量が更新されました。'
    else
      # 新しいアイテムを作成
      @cart_item = current_customer.cart_items.build(
        product_id: product_id,
        bean_state: CartItem.bean_states[bean_state],
        quantity: quantity
      )
      message = 'カートに商品が追加されました。'
    end
  
    # 保存処理
    if @cart_item.save
      redirect_to cart_items_path, notice: message
    else
      render :index, alert: 'カートアイテムの追加に失敗しました。'
    end
  end
  

  def update
    if @cart_item.update(cart_item_params)
      respond_to do |format|
        format.html { redirect_to cart_items_path, notice: "カートが更新されました" }
        format.js { render partial: 'cart_items/cart_item', locals: { cart_item: @cart_item } } # For AJAX
        format.turbo_stream # turbo_streamでJSのレスポンスを使用
      end
    else
      redirect_to cart_items_path, alert: "更新に失敗しました"
    end
  end

  def destroy
    if @cart_item.destroy
      # 削除成功時
      redirect_to request.referer, notice: '商品を削除しました。', status: :see_other
    else
      # 削除失敗時
      flash[:alert] = '商品の削除に失敗しました。'
      redirect_to request.referer || cart_items_path # 元の画面またはフォールバック
    end
  end
  

  private

  def set_cart_item
    @cart_item = current_customer.cart_items.find(params[:id])
  end

  def set_cart_items_and_total_price
    @cart_items = current_customer.cart_items.includes(:product).order(:created_at)
    @total_price = @cart_items.sum(&:subtotal)
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
