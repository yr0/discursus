module ApplicationHelper
  START_YEAR = 2016
  NAVIGATION = {
      main: '/', books: '#', news: 'articles', bookstores: '#', authors: '#', about_us: '#', contacts: '#'
  }.freeze

  def years_active
    [START_YEAR, Time.zone.now.year].uniq.join('&ndash;').html_safe
  end

  def site_navigation(css_class_infix, active_li = :main)
    content_tag :ul, class: "dsc-#{css_class_infix}-nav-items" do
      NAVIGATION.each do |item_name, route|
        link_class = "dsc-#{css_class_infix}-nav-link"
        link_class += ' active' if item_name == active_li
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

  # used for injecting current locale translations into page for JS
  def raw_locale_hash(*exclude_keys)
    I18n.backend.send(:translations)[I18n.locale].with_indifferent_access.except(exclude_keys).to_json.html_safe
  end
end
