require 'rails_helper'
RSpec.describe 'Business Intelligence', type: :request do
  describe "getting a @merchant's total revenue" do
    before :each do
      @merchant = Merchant.create(name: "me")
      @merchant_2 = Merchant.create(name: "not me")

      item = Item.create(name: "item sold", description: "item has been sold and will count towards revenue", unit_price: 2431341, merchant: @merchant)
      item_not_sold = Item.create(name: "item not sold", description: "nobody bought it because its so expensive, this won't count towards revenue!", unit_price: 100007807807807807807070, merchant: @merchant)
      not_my_item = Item.create(name: "item sold", description: "this got sold but isn't mine so it wont count towards revenue", unit_price: 12312, merchant: @merchant_2)

      customer = Customer.create(first_name: "John", last_name: "Smith")

      my_invoice = Invoice.create(customer: customer, merchant: @merchant, status: "shipped")
      InvoiceItem.create(item: item, invoice: my_invoice, quantity: 5, unit_price: 10)
      Transaction.create(invoice: my_invoice, result: "success")

      my_incomplete_invoice = Invoice.create(customer: customer, merchant: @merchant, status: "shipped")
      InvoiceItem.create(item: item_not_sold, invoice: my_incomplete_invoice, quantity: 1, unit_price: 100007807807807807807070)
      Transaction.create(invoice: my_incomplete_invoice, result: "failed") #not good


      not_my_invoice = Invoice.create(customer: customer, merchant: @merchant_2, status: "shipped")
      InvoiceItem.create(item: not_my_item, invoice: not_my_invoice, quantity: 5, unit_price: 100)
      Transaction.create(invoice: not_my_invoice, result: "success")
    end

    it "returns the total revenue of the @merchant when provided with valid info" do
      get api_v1_merchant_total_revenue_path(@merchant.id)
      expect(response.status).to eq(200)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to eq({data: @merchant.total_revenue})
    end

    it "returns 404 when given a nonexisting id" do
      get api_v1_merchant_total_revenue_path("blah")
      expect(response.status).to eq(404)

    end
  end
end
