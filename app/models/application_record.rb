class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 20


  def self.all_within_range(page_num, num_per_page)
    page_num = DEFAULT_PAGE if page_num <= 0
    num_per_page = DEFAULT_PER_PAGE if num_per_page <= 0
    all[get_page_range(page_num, num_per_page)] or []
  end

  private

  def self.get_page_range(num, per_page)
    ((num - 1) * per_page)..((num * per_page) - 1)
  end
end
