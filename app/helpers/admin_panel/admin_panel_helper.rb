# frozen_string_literal: true

module AdminPanel
  module AdminPanelHelper
    NAVIGATION = %w(orders books authors articles team_members promo_codes bookstores series settings).freeze

    # Provided data is completely isolated from user input
    # rubocop:disable Rails/OutputSafety
    def admin_navigation
      content_tag :ul, class: 'sidebar-menu' do
        NAVIGATION.each do |item_name|
          concat content_tag(:li, link_to(I18n.t("admin_panel.#{item_name}.title").gsub(' ', '&nbsp;').html_safe,
                                          url_for([:admin_panel, index_resource(item_name)])),
                             class: within_controller?(item_name) ? 'active' : '')
        end
      end
    end
    # rubocop:enable all

    def within_controller?(name)
      controller_name == name.to_s
    end

    # e.g. series => series_index
    def index_resource(plural_name)
      plural_name.singularize == plural_name ? "#{plural_name}_index" : plural_name
    end
  end
end
