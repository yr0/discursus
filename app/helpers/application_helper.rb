module ApplicationHelper
  START_YEAR = 2016
  NAVIGATION = {
    home: '/', books: '/books', articles: '/articles', bookstores: '#', authors: '/authors', about_us: '/about_us',
    contacts: '#'
  }.freeze
  VARIANTS_ICONS = {
    paperback: 'book', hardcover: 'book', ebook: 'tablet', audio: 'headphones'
  }.freeze # '\f02d' - book, '\f10a' - tablet, '\f025' - headphones

  # Provided data is completely isolated from user input
  def years_active
    [START_YEAR, Time.zone.now.year].uniq.join('&ndash;').html_safe # rubocop:disable Rails/OutputSafety
  end

  # rubocop:disable Rails/OutputSafety Provided data is completely isolated from user input
  def site_navigation(css_class_infix)
    content_tag :ul, class: "dsc-#{css_class_infix}-nav-items" do
      NAVIGATION.each do |item_name, route|
        link_class = "dsc-#{css_class_infix}-nav-link"
        link_class += ' active' if item_name == controller_name
        concat content_tag(:li, link_to(I18n.t("nav.#{item_name}").gsub(' ', '&nbsp;').html_safe, url_for(route),
                                        class: link_class), class: "dsc-#{css_class_infix}-nav-item")
      end
    end
  end
  # rubocop:enable Rails/OutputSafety

  def readable_price(price, show_fractions = true)
    price ||= 0
    fractions = show_fractions ? 2 : 0
    format("%.0#{fractions}f грн", price)
  end

  def readable_date(date, show_time = false)
    return unless date.present?
    date.strftime("#{'%H:%M ' if show_time}%d.%m.%Y")
  end

  # Provided data is validated and completely isolated from user input
  def book_card_price(price)
    format('<b>%d</b>&nbsp;%s', price, t('uah')).html_safe # rubocop:disable Rails/OutputSafety
  end

  # Provided data is completely validated and isolated from user input
  def book_card_variants(available_variants)
    return t('sold') if available_variants.blank?
    available_variants.keys.map do |variant|
      content_tag(:li, fa_icon("#{VARIANTS_ICONS[variant.to_sym]} 2x"),
                  class: 'dsc-book-card-variant-item has-tooltipster', title: t("books.available.#{variant}"),
                  'data-tooltipster-side': 'bottom')
    end.uniq.join.html_safe # rubocop:disable Rails/OutputSafety
  end

  # used for injecting current locale translations into page for JS
  # Provided data is completely isolated from user input
  # rubocop:disable Rails/OutputSafety
  def raw_locale_hash(*exclude_keys)
    I18n.backend.send(:translations)[I18n.locale].with_indifferent_access.except(exclude_keys).to_json.html_safe
  end
  # rubocop:enable Rails/OutputSafety

  def params_with_search(records)
    result = { page: records.next_page }
    result.merge!(@search_query.to_param) if @search_query.try(:nonempty?)
    result
  end

  def view_within_controller?(*names)
    names.map(&:to_s).include?(controller_name)
  end

  def search_url_from_controller
    # returns books_path unless controller search path with key controller_name is provided in the hash
    { 'articles' => articles_path }[controller_name] || books_path
  end
end
