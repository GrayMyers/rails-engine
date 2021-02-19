class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  def self.total_revenue_within_range(start_date,end_date)
    invoices = Invoice.all

    invoices = invoices.where("invoices.created_at > ?",start_date.to_date)

    invoices = invoices.where("invoices.created_at < ?",(end_date.to_date+1.day)) # <= wasn't working here for some reason, so this was a necessary evil.


    invoices.joins(:invoice_items, :transactions).
    where("invoices.status = 'shipped' AND transactions.result = 'success'").
    select("invoice_items.unit_price, invoice_items.quantity").
    sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def self.pending_orders(amount = 10)
    Invoice.joins(:invoice_items, :transactions).
    where("invoices.status != 'shipped' AND transactions.result = 'success'").
    #where("invoices.status != 'shipped'").
    select("invoices.id, invoice_items.unit_price, invoice_items.quantity, invoice_items.unit_price * invoice_items.quantity AS potential_revenue").limit(amount)
  end
end
