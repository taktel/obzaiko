class VendorsController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @vendors = Vendor.all
  end

  def show
    @vendor = Vendor.find(params[:id])
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      flash[:success] = '新規の発注先を作成しました。'
      redirect_to @vendor
    else
      flash.now[:danger] = '発注先の作成に失敗しました。'
      render :new
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update(vendor_params)
      flash[:success] = '発注先情報が更新されました。'
      redirect_to @vendor
    else
      flash.now[:danger] = '更新に失敗しました。'
      render :edit
    end
  end
  
  private
  
  # Strong Parameter
  def vendor_params
    params.require(:vendor).permit(:name, :contact, :email)
  end  
end
