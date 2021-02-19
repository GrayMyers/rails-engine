require 'rails_helper'

describe "Getting a merchant's items", type: :request do
  before :each do
    @merchant = Merchant.create(name: "merchant 1")
    @items =  (0..50).map{ |i| Item.create(name: "item #{i}", unit_price: i, merchant: @merchant) }
  end

  it 'succeeds when there is something to fetch' do
    expected_names = {}
    # get "/api/v1/items/#{item.id}"
    get api_v1_merchant_items_path(@merchant.id)
    expect(response.status).to eq(200)
    json = JSON.parse(response.body, symbolize_names: true)
    (0..50).each do |i|
      expected_hash = {
         id: @items[i].id.to_s,
         type: "item",
         attributes: {description: nil, name: "item #{i}", unit_price: i, merchant_id: @merchant.id}
      }
      expect(json[:data][i]).to eq(expected_hash)
    end
  end
  it 'returns a 404 if merchant is not valid' do
    get api_v1_merchant_items_path("blah")
    expect(response.status).to eq(404)
  end
end
