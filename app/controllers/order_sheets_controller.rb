class OrderSheetsController < ApplicationController
  def index
    @order_sheets = OrderSheet.all
  end

  def show
    @order_sheet = OrderSheet.find(params[:id])
  end

  def new
    initialze_variables
    @orders = Array.new(@row_size, Order.new)
  end

  def create
    @rows_params = rows_params
    if params[:order_button]
      @order_sheet = OrderSheet.new(order_sheet_params_partial)
      rows_params.each do |row| #row={:item_id => "nn", :number => "mm"}
        order = @order_sheet.orders.build(row.merge({:arrival_date => params[:arrival_date], :status => "ordered"}))
        unless order.save
          order.destroy
        end
      end
      if @order_sheet.orders and @order_sheet.save
        redirect_to @order_sheet
      else
        initialze_variables
        @orders = Array.new
        rows_params.each do |row|
          @orders.push(Order.new(row))
        end
        flash.now[:danger] = '新規注文の登録に失敗しました。'
        render :new
      end
    else #newを再表示して在庫切れ予測を計算
      initialze_variables
      @orders = Array.new
      rows_params.each do |row|
        @orders.push(Order.new(row))
      end
      render :new
    end
  end
  
  def edit
    @order_sheet = OrderSheet.find(params[:id])
  end

  def update
    @order_sheet = OrderSheet.find(params[:id])
    if params[:commit] == "更新"
      if @order_sheet.update(order_sheet_params)
        flash[:success] = '発注書が更新されました。'
        redirect_to edit_order_sheet_url(@order_sheet)
      else
        flash.now[:danger] = '更新に失敗しました。'
        render :edit
      end
    else
      @order = @order_sheet.orders.build(item_id: Item.find_by(vendor_id: @order_sheet.vendor_id).id, number: 1)
      if @order.save
        flash[:success] = '物品が1行追加されました。'
        redirect_to edit_order_sheet_url(@order_sheet)
      else
        flash.now[:danger] = '追加に失敗しました。'
        render :edit
      end
    end
  end

  def destroy
    @order_sheet = OrderSheet.find(params[:id])
    @order_sheet.destroy

    flash[:success] = '発注書は正常に削除されました。'
    redirect_to order_sheets_url
  end

  def arrival #発注書から入荷処理
    @order_sheet = OrderSheet.find(params[:id])
  end

  def add #発注書から入荷処理 入荷情報の登録
    @order_sheet = OrderSheet.find(params[:id])
    add_count = Add.count
    order_sheet_params[:orders_attributes].each_value do |order_params|
      if order_params[:status] == "done"
        order = @order_sheet.orders.find(order_params[:id])
        unless order.status == "done" #orderが"done"以外から"done"に変更されたとき、つまり今回入荷したとき
          order.status = "done"
          order.save
          add = order.build_add(item_id: order_params[:item_id], number: order_params[:number], date: order_params[:arrival_date], user_id: current_user.id)
          add.save
        end
      end
    end
    count = Add.count - add_count
    if count > 0
      flash[:success] = "新規の入荷情報が#{count}件追加されました。"
      redirect_to adds_url
    else
      flash.now[:danger] = '入荷情報は追加されませんでした。'
      render :arrival
    end
  end

  private
  
  def initialze_variables
    @vendor_id = params[:vendor_id]
    @items = @items = Item.where(vendor_id: @vendor_id)
    @row_size = (params[:row_size] || 5).to_i
    @order_sheet = current_user.order_sheets.build(order_date: Date.today)
  end

  def rows_params
    params.require(:rows).map { |u| u.permit(:item_id, :number) }
  end
  
  def order_sheet_params_partial
    params.permit(:order_date, :code, :vendor_id, :user_id)
  end

  def order_sheet_params
    params.require(:order_sheet).permit(:order_date, :code, :vendor_id, :user_id, orders_attributes: [:arrival_date, :item_id, :number, :status, :id, :_destroy])
  end
end
