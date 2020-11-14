# frozen_string_literal: true

module ApplicationHelper
  module ShareHelper
    AVAILABLE_SHARE_ACTIONS = [
    ['facebook', ->(_title, link) { "https://www.facebook.com/sharer/sharer.php?u=#{CGI.escape(link)}" }],
    ['twitter', lambda do |title, link|
      "http://twitter.com/share?text=#{CGI.escape(title)}&url=#{CGI.escape(link)}&hashtags=discursus"
    end],
    ['envelope', ->(title, link) { "mailto:?subject=#{CGI.escape(title)}&body=#{CGI.escape(link)}" }]
  ].freeze

  def share_icons_per(title, link)
    AVAILABLE_SHARE_ACTIONS.each do |icon, share_action|
      concat link_to(fa_stacked_icon("#{icon} inverse",
                                     base: 'stop 2x', class: 'dsc-share-icon fa-2x', target: '_blank'),
                     share_action.call(title, link))
    end
  end
  end
end
