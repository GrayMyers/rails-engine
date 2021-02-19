require "rails_helper"

describe "Find one merchant search", type: :request do
  describe "incomplete search for one merchant" do
    before :each do
      @merchants =  (0..50).map{ |i| Merchant.create(name: "merchant #{i}") }
    end

    it 'succeeds when there is something to fetch' do
      name = "merchant 39"
      expected_attributes = {
        name: name
      }
      # get "/api/v1/merchants/#{merchant.id}"
      get api_v1_merchants_find_path(name: name)
      expect(response.status).to eq(200)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data][:id]).to eq(@merchants[39].id.to_s)
      # expect that every attribute we want up above shows up in our output
      expected_attributes.each do |attribute, value|
        expect(json[:data][:attributes][attribute]).to eq(value)
      end
    end
    it 'returns empty data if merchant does not exist' do
      name = "merchant 9000"
      # get "/api/v1/merchants/#{merchant.id}"
      get api_v1_merchants_find_path(name: name)
      expect(response.status).to eq(200)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data]).to eq({})
      # expect that every attribute we want up above shows up in our output
    end
  end
end
