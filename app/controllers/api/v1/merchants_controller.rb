class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all_within_range(params[:page].to_i,params[:per_page].to_i))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id].to_i))
  end

  def items
    merchant = Merchant.find(params[:merchant_id].to_i)
    items = ItemSerializer.new(merchant.items)
    render json: ItemSerializer.new(items)
  end
end
