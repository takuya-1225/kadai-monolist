class ToppagesController < ApplicationController
  def index
    @items = Item.order('updated_at_DESC')
  end
end
