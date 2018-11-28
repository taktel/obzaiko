class ToppagesController < ApplicationController
  def index
    @items = Item.all
  end
end
