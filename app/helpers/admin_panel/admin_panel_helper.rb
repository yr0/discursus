module AdminPanel
  module AdminPanelHelper
    NAVIGATION = %w(books authors articles team_members bookstores)

    def admin_navigation
      content_tag :ul, class: 'sidebar-menu' do
        NAVIGATION.each do |item_name|
          concat content_tag(:li, link_to(I18n.t("admin_panel.#{item_name}.title").gsub(' ', '&nbsp;').html_safe,
                                          url_for([:admin_panel, item_name])),
                             class: within_controller?(item_name) ? 'active' : '')
        end
      end
    end

    def within_controller?(name)
      controller_name == name.to_s
    end
  end
end
