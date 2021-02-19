class ItemRevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes :merchant_id, :name, :description, :unit_price, :revenue
end
