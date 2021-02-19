require "rails_helper"
describe 'fetching a single item', type: :request do
  it 'succeeds when there is something to fetch' do
    merchant = Merchant.create(name: "merchant 1")
    item = merchant.items.create(name: "item to be found", description: "the most useful thing")
    expected_attributes = {
      name: item.name,
      description: item.description,
      merchant_id: merchant.id
    }
    # get "/api/v1/items/#{item.id}"
    get api_v1_item_path(item.id)
    expect(response.status).to eq(200)
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data][:id]).to eq(item.id.to_s)
    # expect that every attribute we want up above shows up in our output
    expected_attributes.each do |attribute, value|
      expect(json[:data][:attributes][attribute]).to eq(value)
    end
  end
  it 'fails with 404 if item does not exist' do
    get api_v1_item_path(999999)
    expect(response.status).to eq(404)
    # as an extension, you can make a custom error message, but a 404 with an empty "data" structure from the serializer is fine too
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json).to have_key(:error)
    expect(json[:error]).to eq('the resource could not be located')
  end
end
