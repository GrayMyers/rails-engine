require "rails_helper"

describe Invoice, type: :model do
  describe "relations" do
    it {should belong_to :customer}
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:items).through(:invoice_items)}

  end
end
