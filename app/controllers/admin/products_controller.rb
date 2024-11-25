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
      redirect_to admin_product_path(@product)
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
  
    respond_to do |format|
      format.html { redirect_to admin_products_path, notice: "商品を削除しました", status: :see_other }
      format.json { head :no_content }
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
