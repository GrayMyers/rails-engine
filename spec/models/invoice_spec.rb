require "rails_helper"

describe Invoice, type: :model do
  describe "relations" do
    it {should belong_to :customer}
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:items).through(:invoice_items)}
  end

  describe "class methods" do
    it "total_revenue_within_range" do
      merchant = Merchant.create(name: "me")
      merchant_2 = Merchant.create(name: "not me")

      item = Item.create(name: "item sold", description: "item has been sold and will count towards revenue", unit_price: 2431341, merchant: merchant)
      item_not_sold = Item.create(name: "item not sold", description: "nobody bought it because its so expensive, this won't count towards revenue!", unit_price: 100007807807807807807070, merchant: merchant)
      not_my_item = Item.create(name: "item sold", description: "this got sold but isn't mine so it wont count towards revenue", unit_price: 12312, merchant: merchant_2)

      customer = Customer.create(first_name: "John", last_name: "Smith")

      my_invoice = Invoice.create(customer: customer, merchant: merchant, status: "shipped")
      InvoiceItem.create(item: item, invoice: my_invoice, quantity: 5, unit_price: 10)
      Transaction.create(invoice: my_invoice, result: "success")

      my_incomplete_invoice = Invoice.create(customer: customer, merchant: merchant, status: "shipped")
      InvoiceItem.create(item: item_not_sold, invoice: my_incomplete_invoice, quantity: 1, unit_price: 100007807807807807807070)
      Transaction.create(invoice: my_incomplete_invoice, result: "failed") #not good


      not_my_invoice = Invoice.create(customer: customer, merchant: merchant_2, status: "shipped")
      InvoiceItem.create(item: not_my_item, invoice: not_my_invoice, quantity: 5, unit_price: 100)
      Transaction.create(invoice: not_my_invoice, result: "success")

      early = "1922-1-1"
      late = "2100-1-1"
      #returns total market revenue when not given a start or end date
      expect(Invoice.total_revenue_within_range(early,late)).to eq(550)
      expect(Invoice.total_revenue_within_range(Date.today,late)).to eq(550)
      expect(Invoice.total_revenue_within_range(early,Date.today)).to eq(0)  
    end

    it "pending_revenue" do
      merchant = Merchant.create(name: "me")
      merchant_2 = Merchant.create(name: "not me")

      item = Item.create(name: "item sold", description: "item has been sold and will count towards revenue", unit_price: 2431341, merchant: merchant)
      item_not_sold = Item.create(name: "item not sold", description: "nobody bought it because its so expensive, this won't count towards revenue!", unit_price: 100007807807807807807070, merchant: merchant)
      not_my_item = Item.create(name: "item sold", description: "this got sold but isn't mine so it wont count towards revenue", unit_price: 12312, merchant: merchant_2)

      customer = Customer.create(first_name: "John", last_name: "Smith")

      my_invoice = Invoice.create(customer: customer, merchant: merchant, status: "shipped")
      InvoiceItem.create(item: item, invoice: my_invoice, quantity: 5, unit_price: 10)
      Transaction.create(invoice: my_invoice, result: "success")
      my_not_shipped_invoices = []
      4.times do |i|
        my_not_shipped_invoices[i] = Invoice.create(customer: customer, merchant: merchant, status: "packaged")
        InvoiceItem.create(item: item_not_sold, invoice: my_not_shipped_invoices[i], quantity: 2, unit_price: 1000)
        Transaction.create(invoice: my_not_shipped_invoices[i], result: "success")
      end

      not_my_invoice = Invoice.create(customer: customer, merchant: merchant_2, status: "shipped")
      InvoiceItem.create(item: not_my_item, invoice: not_my_invoice, quantity: 5, unit_price: 100)
      Transaction.create(invoice: not_my_invoice, result: "success")

      expect(Invoice.pending_orders).to eq(my_not_shipped_invoices)

      expect(Invoice.pending_orders(3)).to eq(my_not_shipped_invoices[0..2])

    end
  end
end
