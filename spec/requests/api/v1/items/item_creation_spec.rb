require "rails_helper"

describe "creating an item", type: :request do
  it "returns the data of the newly created item upon successful creation" do
    merchant = Merchant.create(name: "me")
    i_name = "blah"
    i_desc = "bleh"
    expected_attributes = {
      name: i_name,
      description: i_desc,
      merchant_id: merchant.id
    }
    post api_v1_items_path(name: i_name, description: i_desc, merchant_id: merchant.id)
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(201)
    expected_attributes.each do |attribute, value|
      expect(json[:data][:attributes][attribute]).to eq(value)
    end
  end
  it "returns status 400 when invalid data is given" do
    i_name = "blah"
    i_desc = "bleh"
    post api_v1_items_path()
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(json).to eq({error: "invalid data", status: 400})
  end
end
