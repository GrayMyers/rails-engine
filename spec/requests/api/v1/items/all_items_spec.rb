require "rails_helper"

describe "getting all items", type: :request do
  it 'succeeds when there is something to fetch' do
    expected_names = {}
    merchant = Merchant.create(name: "merchant 1")
    items =  (0..50).map{ |i| expected_names[i] = "item #{i}"; merchant.items.create(name: "item #{i}") }
    # get "/api/v1/items/#{item.id}"
    get api_v1_items_path
    expect(response.status).to eq(200)
    json = JSON.parse(response.body, symbolize_names: true)
    (0..19).each do |i|
      expected_hash = {
         id: items[i].id.to_s,
         type: "item",
         attributes: {description: nil, name: expected_names[i], unit_price: nil, merchant_id: merchant.id}
      }
      expect(json[:data][i]).to eq(expected_hash)
    end
  end
  it 'returns an empty array if data does not exist' do
    get api_v1_items_path
    expect(response.status).to eq(200)
    # as an extension, you can make a custom error message, but a 404 with an empty "data" structure from the serializer is fine too
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json).to eq({data: []})
  end
end
