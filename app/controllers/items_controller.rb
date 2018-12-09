class ItemsController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @items = Item.all
  end
  
  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    category = Category.find(item_params[:category_id])
    @item = category.items.build(item_params)
    if @item.save
      flash[:success] = '新規物品を登録しました。'
      redirect_to root_url
    else
      @items = Item.all
      flash.now[:danger] = '物品の登録に失敗しました。'
      render 'toppages/index'
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:success] = '物品情報が更新されました'
      redirect_to @item
    else
      flash.now[:danger] = '更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    flash[:success] = '物品は正常に削除されました'
    redirect_to root_url
  end
  
  def import
    count = Item.import(params[:file])
    flash[:success] = '物品が' + count.to_s + '個インポートされました'
    redirect_to items_url
  end
  
  private
  
  def item_params
    params.require(:item).permit(:name, :name_en, :code, :category_id, :unit, :storage_location, :vendor_id, :lead_time)
  end
end
