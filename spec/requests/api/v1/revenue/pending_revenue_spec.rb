require "rails_helper"

describe "pending revenue", type: :request do
  before :each do
    merchant = Merchant.create(name: "me")
    merchant_2 = Merchant.create(name: "not me")

    item = Item.create(name: "item sold", description: "item has been sold and will count towards revenue", unit_price: 2431341, merchant: merchant)
    item_not_sold = Item.create(name: "item not sold", description: "nobody bought it because its so expensive, this won't count towards revenue!", unit_price: 100007807807807807807070, merchant: merchant)
    not_my_item = Item.create(name: "item sold", description: "this got sold but isn't mine so it wont count towards revenue", unit_price: 12312, merchant: merchant_2)

    customer = Customer.create(first_name: "John", last_name: "Smith")

    my_invoice = Invoice.create(customer: customer, merchant: merchant, status: "shipped")
    InvoiceItem.create(item: item, invoice: my_invoice, quantity: 5, unit_price: 10)
    Transaction.create(invoice: my_invoice, result: "success")

    my_not_shipped_invoice = Invoice.create(customer: customer, merchant: merchant, status: "packaged")
    InvoiceItem.create(item: item_not_sold, invoice: my_not_shipped_invoice, quantity: 2, unit_price: 1000)
    Transaction.create(invoice: my_not_shipped_invoice, result: "success")


    not_my_invoice = Invoice.create(customer: customer, merchant: merchant_2, status: "shipped")
    InvoiceItem.create(item: not_my_item, invoice: not_my_invoice, quantity: 5, unit_price: 100)
    Transaction.create(invoice: not_my_invoice, result: "success")
  end

  it "returns pending revenue" do
    get api_v1_revenue_unshipped_path
    expect(response.status).to eq(200)

    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data][0][:attributes][:potential_revenue]).to eq(2000)
  end

  it "returns 400 if the quantity is below 1" do
    get api_v1_revenue_unshipped_path(quantity: 0)
    expect(response.status).to eq(400)
  end
end
