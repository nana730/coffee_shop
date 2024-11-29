class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_order

  def show
    @customer = @order.customer # 関連付けが正しいか確認
  end

def update
  if @order.status == 'オーナー確認済み'
    redirect_to admin_order_path(@order), alert: "この注文はすでに確認済みです。" and return
  end
  if @order.update(order_params)
    OrderMailer.status_updated(@order).deliver_now # メール送信
    redirect_to admin_order_path(@order), notice: 'カスタマーにメールを送りました。オーナー確認済みに変更しました。'
  else
    flash.now[:alert] = 'ステータスを"オーナー確認済みにできませんでした。'
    render :show
  end
end


  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end