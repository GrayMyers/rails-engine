class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_all(search_term,min,max)
    result = Item.all

    if search_term
      if search_term == ""
        return []
      end
      result = result.where("name LIKE ?","%#{search_term}%")
    end

    result = result.where("unit_price >= #{min}") if min

    result = result.where("unit_price <= #{max}") if max

    search_term == "" ? [] : result
  end

  def self.by_revenue_descending(limit)
    limit ||= 10
    Item.
    joins(invoice_items: {invoice: :transactions}).
    where("invoices.status='shipped' AND transactions.result='success'").
    group("items.id").
    select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue").
    order("revenue DESC").
    limit(limit)
  end
end
