class ToppagesController < ApplicationController
  def index
    @items = Item.all
    unless params[:order] == ""
      @items = @items.order(params[:order])
    end
    if params[:category_id].to_i > 0
      @items = @items.where(category_id: params[:category_id])
    end
  end
end
