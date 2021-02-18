class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_all(search_term,min,max)
    result = Item.all

    if search_term
      result = result.where("name LIKE ?","%#{search_term}%")
    end

    if min
      result = result.where("unit_price >= #{min}")
    end

    if max
      result = result.where("unit_price <= #{max}")
    end

    result
  end
end
