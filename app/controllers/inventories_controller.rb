class InventoriesController < ApplicationController
  def index
  end

  def create
    @errormsg = ""
    params[:numbers].each do |item_id, number|
      unless number == ""
        @inventory = Item.find(item_id).inventories.build(:type => params[:type], :date => params[:date], :number => number, :user_id => params[:user_id], :item_id => item_id)
        if Inventory.find_by(type: @inventory.type, date: @inventory.date, item_id: @inventory.item_id)
          @errormsg = @errormsg + Item.find(@inventory.item_id).name+" : 同じ日付では登録できません。\n"
        else
          @inventory.save
        end
      end
    end
    if @errormsg ==""
      flash[:success] = '情報を登録しました。'
    else
      flash[:danger] = @errormsg
    end
    
    if params[:type] = 'Check'
      redirect_to check_url
    else
      redirect_to add_url
    end
  end

  def edit
    @inventory = Inventory.find(params[:id])
  end

  def update
    @inventory = Inventory.find(params[:id])
    
    if Inventory.where.not(id: params[:id]).find_by(type: params[:type], date: params[:date], item_id: params[:item_id])
      flash.now[:danger] = Item.find(params[:item_id]).name+" : 同じ日付では登録できません"
      render :edit
    elsif @inventory.update(:type => params[:type], :date => params[:date], :number => params[:number], :user_id => params[:user_id], :item_id => params[:item_id])
      flash[:success] = '情報を更新しました。'
      redirect_to item_url(id: params[:item_id])
    else
      flash.now[:danger] = '情報を更新できませんでした'
      render :edit
    end
  end

  def destroy
    @inventory = Inventory.find(params[:id])
    @item_id = @inventory.item_id
    @inventory.destroy

    flash[:success] = '正常に削除されました'
    redirect_to item_url(id: @item_id)
  end

  def check
    @type = 'Check'
    @items = Item.all
    if params[:category_id].to_i > 0
      @items = @items.where(category_id: params[:category_id])
    end
    @lastchecks = Hash.new
    @items.each do |item|
      @lastchecks[item.id] = item.checks.order(:date).last
    end
  end
  
  def add
    @type = 'Add'
    @items = Item.all
    if params[:category_id].to_i > 0
      @items = @items.where(category_id: params[:category_id])
    end
    @lastchecks = Hash.new
    @items.each do |item|
      @lastchecks[item.id] = item.checks.order(:date).last
    end
  end
end