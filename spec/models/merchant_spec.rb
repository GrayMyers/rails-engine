require "rails_helper"

describe Merchant, type: :model do
  describe "relations" do
    it {should have_many :items}
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
