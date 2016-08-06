module ApplicationHelper
  START_YEAR = 2016

  def home_navigation
    items = %w(main books news bookstores authors about_us contacts)
    content_tag :ul do
      items.each do |li|
        concat content_tag(:li, link_to(I18n.t("nav.#{li}").gsub(' ', '&nbsp;').html_safe, '#',
                                        class: li == 'main' ? 'active' : ''))
      end
    end
  end

  def years_active
    [START_YEAR, Time.zone.now.year].uniq.join('&ndash;').html_safe
  end
end
