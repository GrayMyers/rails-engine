class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_all(search_term,min,max)
    result = Item.all

    result = result.where("name LIKE ?","%#{search_term}%") if search_term

    result = result.where("unit_price >= #{min}") if min

    result = result.where("unit_price <= #{max}") if max

    result
  end
end
