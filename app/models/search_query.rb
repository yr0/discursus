class SearchQuery
  include ActiveModel::Model

  ALLOWED_ATTRIBUTES = %i(order_by order_by_desc text_query category_ids price_range search_all_categories).freeze
  DEFAULT_ORDER_BY_DESC = { title: 0, price: 0, date: 1 }.freeze
  DEFAULT_ORDER_BY = :date

  attr_accessor(*ALLOWED_ATTRIBUTES)

  def initialize(*args)
    super
    self.order_by_desc ||= DEFAULT_ORDER_BY_DESC
    self.order_by ||= DEFAULT_ORDER_BY
  end

  def category_ids=(categories)
    @category_ids = search_all_categories.to_i.nonzero? ? [] : categories.reject(&:blank?).map(&:to_i)
  end
end
