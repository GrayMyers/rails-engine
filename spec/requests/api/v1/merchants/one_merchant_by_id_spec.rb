require "rails_helper"

describe "Get one merchant by id", type: :request do
  it 'succeeds when there is something to fetch' do
    merchant = Merchant.create(name: "merchant to be found")
    expected_attributes = {
      name: merchant.name
    }
    # get "/api/v1/merchants/#{merchant.id}"
    get api_v1_merchant_path(merchant.id)
    expect(response.status).to eq(200)
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data][:id]).to eq(merchant.id.to_s)
    # expect that every attribute we want up above shows up in our output
    expected_attributes.each do |attribute, value|
      expect(json[:data][:attributes][attribute]).to eq(value)
    end
  end
  it 'fails with 404 if merchant does not exist' do
    get api_v1_merchant_path(999999)
    expect(response.status).to eq(404)
    # as an extension, you can make a custom error message, but a 404 with an empty "data" structure from the serializer is fine too
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json).to have_key(:error)
    expect(json[:error]).to eq('the resource could not be located')
  end
end
