class PagesController < ApplicationController
  def home
    @articles = Article.order(created_at: :desc) # 最新記事を3件取得
  end
end
