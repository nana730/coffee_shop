class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.preload(:orders).latest
  end

  def show
    @customer = Customer.find(params[:id])
  end
end
