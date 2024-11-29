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
  
    # トランザクション開始
    begin
      ActiveRecord::Base.transaction do
        # ステータス更新
        if @order.update!(order_params)
          # メール送信をトランザクション内で実行
          begin
            OrderMailer.status_updated(@order).deliver_now
          rescue StandardError => e
            # メール送信失敗時にトランザクションをロールバック
            raise "メール送信失敗: #{e.message}"
          end
        else
          raise 'ステータス更新失敗'
        end
      end
  
      # メール送信が成功した場合
      redirect_to admin_order_path(@order), notice: 'カスタマーにメールを送りました。オーナー確認済みに変更しました。'
    rescue StandardError => e
      # トランザクション失敗時にロールバックし、エラーメッセージを表示
      flash[:alert] = "ステータスを'オーナー確認済みにできませんでした。"
      redirect_to admin_order_path(@order) # リダイレクトで再読み込み
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