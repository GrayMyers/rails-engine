class Api::V1::BusinessIntelligenceController < ApplicationController
  def total_revenue
    merchant = Merchant.find(params[:merchant_id])
    render json: {data: merchant.total_revenue}
  end

  def total_revenue_within_range
    revenue = Invoice.total_revenue_within_range(params[:start_date],params[:end_date])
    render json: {data: revenue}
  end
end
