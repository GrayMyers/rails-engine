class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.total_revenue_within_range(start_date,end_date)
    invoices = Invoice.all

    invoices = invoices.where("invoices.created_at > ?",start_date.to_date) if start_date

    invoices = invoices.where("invoices.created_at < ?",end_date.to_date) if end_date

    invoices.joins(:invoice_items, :transactions).
    where("invoices.status = 'shipped' AND transactions.result = 'success'").
    select("invoice_items.unit_price, invoice_items.quantity").
    sum("invoice_items.unit_price * invoice_items.quantity")
  end
end
