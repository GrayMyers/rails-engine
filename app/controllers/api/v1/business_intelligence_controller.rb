class Api::V1::BusinessIntelligenceController < ApplicationController
  def total_revenue
    merchant = Merchant.find(params[:merchant_id])
    render json: {data: merchant.total_revenue}
  end
end
