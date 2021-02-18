class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.find_one(search_term)
    Merchant.all.where("name LIKE ?","%#{search_term}%").limit(1)[0]
  end
end
