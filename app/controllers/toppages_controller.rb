class ToppagesController < ApplicationController
  def index
    @items = items_sorted_by(params[:order], params[:category_id])
  end
end
