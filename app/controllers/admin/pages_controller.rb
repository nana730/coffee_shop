class Admin::PagesController < ApplicationController
  before_action :authenticate_admin!

  def home
    @status = search_params[:status]
    @selected = params[:status] || 'all' # 初期値を設定
    @orders = filter_orders(Order.includes(:customer).order(created_at: :desc).page(params[:page]).per(12), @selected)
    @items = @orders # _paginator.html.erb で @items を使用
    @today_total_orders = total_orders(today_orders)
    @waiting_orders = total_orders(waiting_orders)
  end

  private

  # ステータスでオーダーをフィルタリングする
  def filter_orders(orders, status)
    case status
    when "オーナー確認待ち"
      orders.where(status: :オーナー確認待ち)
    when "オーナー確認済み"
      orders.where(status: :オーナー確認済み)
    else
      orders
    end
  end

  # 今日のオーダーを取得するためのメソッド
  def today_orders
    Order.includes(:customer).where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end

  # オーナー確認待ちのオーダーを取得するメソッド
  def waiting_orders
    Order.includes(:customer).where(status: :オーナー確認待ち)
  end

  # オーダーのカウントを返すメソッド
  def total_orders(orders)
    orders.count
  end

  def search_params
    params.permit(:status, :page) # 必要なパラメータだけ許可
  end
end

