module BooksHelper
  AVAILABLE_SHARE_ACTIONS = [
      ['facebook', ->(_record, link) { "https://www.facebook.com/sharer/sharer.php?u=#{URI.encode(link)}" }],
      ['twitter', ->(record, link) {
        "http://twitter.com/share?text=#{URI.encode(record.title)}&url=#{URI.encode(link)}&hashtags=discursus"
      }],
      ['envelope', ->(record, link) { "mailto:?subject=#{URI.encode(record.title)}&body=#{URI.encode(link)}" }]
  ].freeze

  def share_icons_for(book)
    AVAILABLE_SHARE_ACTIONS.each do |icon, share_action|
      concat link_to(fa_stacked_icon("#{icon} inverse", base: 'stop 2x', class: 'dsc-book-share-icon fa-2x',
                                     target: '_blank'),
                     share_action.call(book, book_url(book)))
    end
  end

  def random_books(except_book = nil, limit = 4)
    Book.where.not(id: except_book&.id).where(is_available: true)
        .reorder('RANDOM(), books.published_at DESC').limit(limit)
  end
end
