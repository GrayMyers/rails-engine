require 'rails_helper'

describe 'updating an item', type: :request do
  it 'succeeds when there is something to fetch' do
    merchant = Merchant.create(name: "merchant 1")
    item = merchant.items.create(name: "item to be found", description: "the most useful thing")
    expected_attributes = {
      name: item.name,
      description: "modified description",
      merchant_id: merchant.id
    }
    # get "/api/v1/items/#{item.id}"
    patch api_v1_item_path(item.id, description: "modified description")
    expect(response.status).to eq(201)
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data][:id]).to eq(item.id.to_s)
    # expect that every attribute we want up above shows up in our output
    expected_attributes.each do |attribute, value|
      expect(json[:data][:attributes][attribute]).to eq(value)
    end
  end
  it "fails with 400 if invalid data is provided" do
    merchant = Merchant.create(name: "merchant 1")
    item = merchant.items.create(name: "item to be found", description: "the most useful thing")

    patch api_v1_item_path(item.id, merchant_id: "modified id")
    json = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)

    expect(json).to have_key(:error)
    expect(json[:error]).to eq('invalid data')
  end

  it 'fails with 404 if item does not exist' do
    patch api_v1_item_path(999999999999999, description: "modified description")
    expect(response.status).to eq(404)
    # as an extension, you can make a custom error message, but a 404 with an empty "data" structure from the serializer is fine too
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json).to have_key(:error)
    expect(json[:error]).to eq('the resource could not be located')
  end
end
