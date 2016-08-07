module HomeHelper
  def home_navigation
    items = %w(main books news bookstores authors about_us contacts)
    default_active_li = 'main'
    content_tag :ul, class: 'dsc-home-nav-items' do
      items.each do |li|
        link_class = "dsc-home-nav-link#{li == default_active_li ? ' active' : ''}"
        concat content_tag(:li, link_to(I18n.t("nav.#{li}").gsub(' ', '&nbsp;').html_safe, '#',
                                        class: link_class), class: 'dsc-home-nav-item')
      end
    end
  end
end
