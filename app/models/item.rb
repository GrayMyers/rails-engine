class Item < ApplicationRecord
  belongs_to :merchant

  def find_all(search_term,min,max)
    Item
    .where("regexp_matches(name, ?)", "#{search}") if search_term
    .where("price > #{min}") if min
    .where("price < #{max}") if max
  end
end
