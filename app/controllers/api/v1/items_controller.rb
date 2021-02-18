class Api::V1::ItemsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id].to_i)
    items = ItemSerializer.new(merchant.items)
    render json: items
  end
end
