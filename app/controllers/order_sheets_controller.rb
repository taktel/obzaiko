class OrderSheetsController < ApplicationController
  def index
  end

  def new
    @vendor = params[:vendor]
    @items = @vendor.blank? ? @items = Item.all : @items = Item.where(vendor: params[:vendor])
    @rows = params[:rows] || 1
    @order_sheet = current_user.order_sheets.build(order_date: Date.today)
    @orders = Array.new(@rows.to_i, @order_sheet.orders.build(status: 'planned'))
  end

  def create
  end
end
