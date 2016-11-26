class SearchQuery
  include ActiveModel::Model

  ALLOWED_ATTRIBUTES = %i(order_field order_by_desc text_query category_ids price_range
                          search_all_categories author_ids).freeze
  DEFAULT_ORDER_BY_DESC = { order_title: 0, main_price: 0, created_at: 1 }.freeze
  DEFAULT_ORDER_FIELD = :created_at
  RESULTS_PER_PAGE = 8

  attr_accessor(*ALLOWED_ATTRIBUTES)

  def initialize(*args)
    super
    self.order_by_desc ||= DEFAULT_ORDER_BY_DESC
    self.order_field ||= DEFAULT_ORDER_FIELD
  end

  def to_sunspot(page = 1)
    Proc.new do
      order_by *order_conditions
      paginate page: page, per_page: RESULTS_PER_PAGE

      fulltext(text_query) if text_query.present?
      with(:category_ids, category_ids) if category_ids.present?
      with(:author_ids, author_ids) if author_ids.present?
    end
  end

  def category_ids=(categories)
    @category_ids = search_all_categories.to_i.nonzero? ? [] : categories.reject(&:blank?).map(&:to_i)
  end

  def author_ids=(authors)
    @author_ids = authors.reject(&:blank?).map(&:to_i)
  end

  def text_query=(query)
    @text_query = query.try(:downcase)
  end

  def nonempty?
    [text_query, category_ids, price_range, author_ids].any?(&:present?) || order_field != DEFAULT_ORDER_FIELD ||
        order_by_desc != DEFAULT_ORDER_BY_DESC
  end

  def to_param
    { search_query: ALLOWED_ATTRIBUTES.map { |a| [a, send(a)] }.to_h }
  end

  private

  def order_conditions
    order_direction = order_by_desc[order_field].to_i.zero? ? :asc : :desc
    [order_field, order_direction]
  end
end
