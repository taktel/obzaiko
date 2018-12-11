class ToppagesController < ApplicationController
  def index
    session[:per_page] = params[:per_page] || session[:per_page] || Item.default_per_page
    @items = items_sorted_by(params[:order], params[:category_id]).page(params[:page]).per(session[:per_page])
  end
end
