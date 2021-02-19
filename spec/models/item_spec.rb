require "rails_helper"

describe Item, type: :model do
  describe "relations" do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  describe "class methods" do
    before :each do
      @merchant = Merchant.create(name: "merchant 1")
      @items =  (0..50).map{ |i| Item.create(name: "item #{i}", unit_price: i, merchant: @merchant) }
    end

    it "by_revenue_descending" do
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

      expect(Item.by_revenue_descending(5)).to eq([not_my_item, item])
      expect(Item.by_revenue_descending(1)).to eq([not_my_item])

    end

    it "find_all" do
      items_all_high_max = Item.find_all(nil,nil,100000000000)
      expect(items_all_high_max).to eq(@items)

      items_all_low_min = Item.find_all(nil,0,nil)
      expect(items_all_high_max).to eq(@items)

      items_all_ambiguous_name = Item.find_all("item",nil,nil)
      expect(items_all_ambiguous_name).to eq(@items)

      last_item_high_min = Item.find_all(nil,50,nil)
      expect(last_item_high_min).to eq([@items[50]])

      first_item_low_max = Item.find_all(nil,nil,0)
      expect(first_item_low_max).to eq([@items[0]])

      twenty_first_item_by_name = Item.find_all("item 20",nil,nil)
      expect(twenty_first_item_by_name).to eq([@items[20]])

      non_existant_item = Item.find_all("not an item",nil,nil)
      expect(non_existant_item).to eq([])
    end
  end
end
