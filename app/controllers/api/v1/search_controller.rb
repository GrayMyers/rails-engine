class Api::V1::SearchController < ApplicationController
  def find_one_merchant
    results = Merchant.find_one(params[:name])
    render json: MerchantSerializer.new(results)
  end

  def find_all_items
    results = Item.find_all(params[:name])
    render json: MerchantSerializer.new(results)
  end
end
