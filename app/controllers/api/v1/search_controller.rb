class Api::V1::SearchController < ApplicationController
  def find_one_merchant
    results = Merchant.find_one(params[:name].downcase)
    if results
      render json: MerchantSerializer.new(results)
    else
      render json: {data: {}}
    end
  end

  def find_all_items
    results = Item.find_all(params[:name], params[:min_price], params[:max_price])
    render json: ItemSerializer.new(results)
  end
end
