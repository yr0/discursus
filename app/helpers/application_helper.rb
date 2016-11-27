module ApplicationHelper
  START_YEAR = 2016
  NAVIGATION = {
      home: '/', books: '/books', articles: '/articles', bookstores: '#', authors: '/authors', about_us: '/about_us',
      contacts: '#'
  }.freeze
  VARIANTS_ICONS = {
      paperback: 'book', hardcover: 'book', ebook: 'tablet', audio: 'headphones'
  }

  def years_active
    [START_YEAR, Time.zone.now.year].uniq.join('&ndash;').html_safe
  end

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

  def readable_price(price, show_fractions = true)
    price ||= 0
    fractions = show_fractions ? 2 : 0
    sprintf("₴%.0#{fractions}f", price)
  end

  def readable_date(date, show_time = false)
    return unless date.present?
    date.strftime("#{'%H:%M ' if show_time}%d.%m.%Y")
  end

  def book_card_price(price)
    sprintf('<b>%d</b>&nbsp;%s', price, t('uah')).html_safe
  end

  def book_card_variants(available_variants)
    return t('sold') if available_variants.blank?
    available_variants.keys.map do |variant|
      content_tag(:li, fa_icon("#{VARIANTS_ICONS[variant.to_sym]} 2x"),
                  class: 'dsc-book-card-variant-item has-tooltipster', title: t("books.available.#{variant}"),
                  'data-tooltipster-side': 'bottom')
    end.uniq.join.html_safe
  end

  # used for injecting current locale translations into page for JS
  def raw_locale_hash(*exclude_keys)
    I18n.backend.send(:translations)[I18n.locale].with_indifferent_access.except(exclude_keys).to_json.html_safe
  end

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
    {
        'articles' => articles_path
    }[controller_name] || books_path
  end
end
