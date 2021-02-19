class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.find_one(search_term)
    Merchant.all.where("name LIKE ?","%#{search_term}%").limit(1)[0]
  end

  def total_revenue
    Invoice.where(merchant_id: id).
    joins(:invoice_items, :transactions).
    where("invoices.status = 'shipped' AND transactions.result = 'success'").
    select("invoice_items.unit_price, invoice_items.quantity").
    sum("invoice_items.unit_price * invoice_items.quantity")
  end
end
