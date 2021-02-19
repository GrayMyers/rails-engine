class Api::V1::RevenueController < ApplicationController
  def total_revenue
    merchant = Merchant.find(params[:merchant_id])
    revenue = merchant.total_revenue
    render json: {
      data: {
        id: merchant.id.to_s,
        type: "merchant_revenue",
        attributes: {
          revenue: revenue
        }
      }
    }
  end

  def total_revenue_within_range

    start_date = (params[:start] or params[:start_date])
    end_date = (params[:end] or params[:end_date])

    if is_blank?(start_date) or is_blank?(end_date) or start_date.to_date > end_date.to_date
      render json: {:error => "invalid data", status: 400}.to_json, status: 400
    else

      revenue = Invoice.total_revenue_within_range(start_date,end_date)
      render json: {
        data: {
          type: "revenue",
          id: nil,
          attributes: {
            revenue: revenue
          }
        }
      }
    end
  end

  def pending_revenue
    if params[:quantity] and params[:quantity].to_i < 1
      render json: {:error => "invalid data", status: 400}.to_json, status: 400
    else
      orders = Invoice.pending_orders(params[:quantity])
      formatted_orders = orders.map do |order|
        {type: "unshipped_order",
        id: order.id.to_s,
        attributes: {
          potential_revenue: order.potential_revenue
        }}
      end
      render json: {data: formatted_orders}
    end
  end

  def items_by_revenue
    params[:quantity] = params[:quantity].to_i if params[:quantity]
    if params[:quantity] and params[:quantity] < 1
      render json: {:error => "invalid data", status: 400}.to_json, status: 400
    else
      items = Item.by_revenue_descending(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    end
  end

  private

  def is_blank?(string)
    !string or string == ""
  end
end
