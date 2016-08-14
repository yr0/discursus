module ApplicationHelper
  START_YEAR = 2016
  NAVIGATION = {
    main: '/', books: '#', news: '#', bookstores: '#', authors: '#', about_us: '#', contacts: '#'
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
end
