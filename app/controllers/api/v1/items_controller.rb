class Api::V1::ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token


  def index
    render json: ItemSerializer.new(Item.all_within_range(params[:page].to_i,params[:per_page].to_i))
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id].to_i))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201

    else
      render json: {:error => "invalid data", status: 400}.to_json, status: 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    render json: {status: 204}.to_json, status: 204
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item), status: 201
    else
      render json: {:error => "invalid data", status: 400}.to_json, status: 400
    end
  end

  def merchant
    item = Item.find(params[:item_id])
    merchant = item.merchant
    render json: MerchantSerializer.new(merchant)
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
