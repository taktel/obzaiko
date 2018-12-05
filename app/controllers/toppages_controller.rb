class ToppagesController < ApplicationController
  def index
    @items = Item.all
    if params[:order] == ""
      @items = @items.order(:id)
    else
      @items = @items.order(params[:order])
    end
    if params[:category_id].to_i > 0
      @items = @items.where(category_id: params[:category_id])
    end
  end
end
