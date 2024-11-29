class Customer::ArticlesController < ApplicationController
  def index
    @articles = Article.order(created_at: :desc)
  end

  def show
    @article = Article.find(params[:id])
  end
end
