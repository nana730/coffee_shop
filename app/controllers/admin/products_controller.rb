class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.with_attached_image.order(:created_at).page(params[:page]).per(12)
    @items = @products # _paginator.html.erb で @items を使用
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      flash[:notice] = "商品を追加しました。"
      redirect_to admin_product_path(@product)
    else
      flash[:alert] = "商品を追加できませんでした。"
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @product.update(product_params)
      flash[:notice] = "商品の内容を変更しました。"
      redirect_to admin_product_path(@product)
    else
      flash[:alert] = "商品の変更に失敗しました。"
      render :edit
    end
  end

  def destroy
    if @product.destroy
      respond_to do |format|
        format.html { redirect_to admin_products_path, notice: "商品を削除しました", status: :see_other }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = "商品の削除に失敗しました"
          redirect_to request.referer || admin_products_path # 元の画面に戻す
        end
      end
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :image, :acidity, :bitterness, :sweetness, :aroma, :body )
  end
end
