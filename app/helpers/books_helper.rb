module BooksHelper
  AVAILABLE_SHARE_PROVIDERS = %w(facebook twitter vk).freeze

  def share_icons_for(_book)
    AVAILABLE_SHARE_PROVIDERS.each do |provider|
      concat fa_stacked_icon "#{provider} inverse", base: 'stop 2x', class: 'dsc-book-share-icon fa-2x'
    end
  end
end
