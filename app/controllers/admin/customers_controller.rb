class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  # ここを変更
  def index
    @customers = Customer.includes(:orders).latest
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
