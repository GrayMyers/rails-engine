require "rails_helper"

describe Item, type: :model do
  describe "relations" do
    it {should belong_to :merchant}
  end

  describe "class methods" do
    before :each do
      @merchant = Merchant.create(name: "merchant 1")
      @items =  (0..50).map{ |i| Item.create(name: "item #{i}", unit_price: i, merchant: @merchant) }
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

      invalid_params = Item.find_all(nil,nil,nil)
      expect(invalid_params).to eq([])
    end
  end
end
