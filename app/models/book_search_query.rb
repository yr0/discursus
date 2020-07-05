class BookSearchQuery
  include ActiveModel::Model

  ALLOWED_ATTRIBUTES = %i(order_field order_by_desc text_query category_ids
                          search_all_categories author_ids).freeze
  DEFAULT_ORDER_BY_DESC = { title_for_sorting: 0, main_price: 0, published_at: 1 }.freeze
  DEFAULT_ORDER_FIELD = :published_at
  RESULTS_PER_PAGE = 8

  attr_accessor(*ALLOWED_ATTRIBUTES)

  def initialize(*args)
    super
    self.order_by_desc ||= DEFAULT_ORDER_BY_DESC
    self.order_field = DEFAULT_ORDER_FIELD unless DEFAULT_ORDER_BY_DESC.key?(order_field&.to_sym)
    self.category_ids ||= []
    self.author_ids ||= []

    process_category_ids
    process_author_ids
    process_text_query
  end

  def search(page = 1)
    Book.search(include: %i(authors categories), &to_sunspot(page))
  end

  # rubocop:disable Metrics/AbcSize
  # We pass this block to search query
  def to_sunspot(page)
    proc do
      with(:is_available, true)

      order_by(:is_top, :desc) if default?
      order_by(*order_conditions)
      paginate page: page, per_page: RESULTS_PER_PAGE

      fulltext(text_query) if text_query.present?
      with(:category_ids, category_ids) if category_ids.present?
      with(:author_ids, author_ids) if author_ids.present?
    end
  end
  # rubocop:enable all

  # Check if search query involves default behavior without changes
  def default?
    [text_query, category_ids, author_ids].all?(&:blank?) &&
      order_field == DEFAULT_ORDER_FIELD &&
      order_by_desc == DEFAULT_ORDER_BY_DESC
  end

  def to_param
    { search_query: as_json }
  end

  private

  def order_conditions
    order_direction = order_by_desc[order_field].to_i.zero? ? :asc : :desc
    [order_field, order_direction]
  end

  def process_category_ids
    @category_ids = search_all_categories.to_i.nonzero? ? [] : category_ids.reject(&:blank?).map(&:to_i)
  end

  def process_author_ids
    @author_ids = author_ids.reject(&:blank?).map(&:to_i)
  end

  def process_text_query
    @text_query = @text_query.try(:downcase)
  end
end
