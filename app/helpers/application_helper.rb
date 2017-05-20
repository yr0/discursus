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
  def site_navigation(css_class_infix, no_turbolinks = false)
    content_tag :ul, class: "dsc-#{css_class_infix}-nav-items" do
      concat content_tag(:li, link_to(I18n.t('nav.admin_panel'), admin_panel_path,
                                      class: "dsc-#{css_class_infix}-nav-link",
                                      style: 'color: green', 'data-turbolinks': false),
                         class: "dsc-#{css_class_infix}-nav-item") if current_admin.present?
      NAVIGATION.each do |item_name, route|
        link_class = "dsc-#{css_class_infix}-nav-link"
        link_class += ' active' if item_name == controller_name
        concat content_tag(:li,
                           link_to(I18n.t("nav.#{item_name}").gsub(' ', '&nbsp;').html_safe, url_for(route),
                                   class: link_class, 'data-turbolinks': !no_turbolinks),
                           class: "dsc-#{css_class_infix}-nav-item")
      end
    end
  end
  # rubocop:enable Rails/OutputSafety

  def readable_price(price, show_fractions = true, show_currency = true)
    price ||= 0
    # hide fractions only if price has no fraction part and the show_fractions is set to false
    show_fractions ||= (price % 1).nonzero?
    currency = show_currency ? " #{t(Rails.configuration.default_currency)}" : ''
    format("%.0#{show_fractions ? 2 : 0}f%s", price, currency)
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
  def book_card_variants(available_variants, bought = false)
    return t('sold') if available_variants.blank?
    available_variants = available_variants.keys unless available_variants.is_a?(Array)
    available_variants.map do |variant|
      content_tag(:li, fa_icon("#{VARIANTS_ICONS[variant.to_sym]} 2x"),
                  class: 'dsc-book-card-variant-item has-tooltipster',
                  title: bought ? t("personal.bookshelf.bought_as.#{variant}") : t("books.available.#{variant}"),
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
    result.merge!(@search_query&.to_param || {}) unless @search_query.try(:default?)
    result
  end

  def view_within_controller?(*names, **options)
    names.map(&:to_s).include?(controller_name) && (options[:actions].empty? || options[:actions].include?(action_name))
  end

  def search_url_from_controller
    # returns books_path unless controller search path with key controller_name is provided in the hash
    { 'articles' => articles_path }[controller_name] || books_path
  end
end
