require "rails_helper"

describe Merchant, type: :model do
  describe "relations" do
    it {should have_many :items}
    it {should have_many :invoices}
  end

  describe "instance methods" do
    it "total_revenue" do
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

      expect(merchant.total_revenue).to eq(50)
      expect(merchant_2.total_revenue).to eq(500)
    end
  end

  describe "class methods" do
    before :each do
      @merchants =  (0..50).map{ |i| Merchant.create(name: "merchant #{i}") }
    end

    it "find_one" do
      merchant_all = Merchant.find_one("merchant")
      expect(@merchants).to include(merchant_all)

      merchant_one = Merchant.find_one("merchant 30")
      expect(merchant_one).to eq(@merchants[30])

      merchant_none = Merchant.find_one("not a merchant")
      expect(merchant_none).to eq(nil)
    end

    it "all_within_range" do
      page1 = Merchant.all_within_range(0,0) #testing sad path default values
      expect(page1).to eq(Merchant.all_within_range(1,20))
      expect(page1).to eq(@merchants[0..19])

      page3 = Merchant.all_within_range(3,20) #test that it can return less than 20
      expect(page3).to eq(@merchants[40..50])

      page4 = Merchant.all_within_range(4,20) #test that it returns an empty array if no data is present
      expect(page4).to eq([])

      diffsize = Merchant.all_within_range(1,40)
      expect(diffsize).to eq(@merchants[0..39])
    end
  end
end
