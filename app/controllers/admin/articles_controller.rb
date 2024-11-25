class Admin::ArticlesController < ApplicationController
    before_action :authenticate_admin!  # 管理者認証を追加

    def index
      @articles = Article.all
    end

    def show
      @article = Article.find(params[:id])
    end

    def new
      @article = Article.new
    end

    def create
      @article = Article.new(article_params)
      if @article.save
        redirect_to admin_articles_path, notice: '記事が作成されました'
      else
        render :new
      end
    end

    def edit
      @article = Article.find(params[:id])
    end

    def update
      @article = Article.find(params[:id])
      if @article.update(article_params)
        redirect_to admin_article_path(@article), notice: '記事が更新されました'
      else
        render :edit
      end
    end

    def destroy
      @article = Article.find(params[:id])
      @article.destroy
      redirect_to admin_articles_path, notice: '記事が削除されました'
    end

    private

    def article_params
      params.require(:article).permit(:title, :description, :image)
    end
  end