require "rails_helper"

describe "items ranked by revenue descending", type: :request do
  before :each do

  end

  it "returns a list of items sorted by descending revenue if provided with proper data" do
    get api_v1_items_revenue
    expect(response.status).to eq(200)

    
  end

  it "returns the amount of items specified" do
    get api_v1_items_revenue(quantity: 1)
    expect(response.status).to eq(200)

  end

  it "returns 400 if an invalid quantity was specified" do
    get api_v1_items_revenue(quantity: 0)
    expect(response.status).to eq(400)

  end
end
