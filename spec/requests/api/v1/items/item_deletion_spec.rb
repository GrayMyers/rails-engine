require "rails_helper"

describe "deleting an item", type: :request do
  it "returns the data of the newly created item upon successful creation" do
    merchant = Merchant.create(name: "me")
    item = Item.create(name: "item", description: "desc", unit_price: 5, merchant: merchant)
    delete api_v1_item_path(item.id)

    expect(response.status).to eq(204)
  end
  it "returns status 400 when invalid data is given" do
    delete api_v1_item_path(284384982394732)
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
  end
end
