class CategoriesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = '新規の物品カテゴリを作成しました。'
      redirect_to @category
    else
      flash.now[:danger] = '物品カテゴリの作成に失敗しました。'
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:success] = 'カテゴリ名が更新されました。'
      redirect_to @category
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    flash[:success] = 'カテゴリは正常に削除されました。'
    redirect_to categories_url
  end
  
  private
  
  # Strong Parameter
  def category_params
    params.require(:category).permit(:name)
  end  
end
