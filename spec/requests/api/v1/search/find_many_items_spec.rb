require "rails_helper"

describe "Find many items search", type: :request do 
  describe "searching for all items" do
    before :each do
      @merchant = Merchant.create(name: "merchant 1")
      @items =  (0..50).map{ |i| Item.create(name: "item #{i}", unit_price: i, merchant: @merchant) }
    end

    it "returns item data when applicable" do
      get api_v1_items_find_all_path(name: "item", min_price: 10, max_price: 19) #ambiguous name, range limited by price min and max
      expect(response.status).to eq(200)
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data].count).to eq(10)

      expect(json[:data][0][:attributes][:name]).to eq("item 10")

      expect(json[:data].last[:attributes][:name]).to eq("item 19")

    end

    it "returns an empty array if no data can be found" do
      get api_v1_items_find_all_path(name: "no item here!")
      expect(response.status).to eq(200)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(0)
    end
  end
end
