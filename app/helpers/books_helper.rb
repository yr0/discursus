# frozen_string_literal: true

module BooksHelper
  AVAILABLE_SHARE_ACTIONS = [
    ['facebook', ->(_record, link) { "https://www.facebook.com/sharer/sharer.php?u=#{CGI.escape(link)}" }],
    ['twitter', lambda do |record, link|
      "http://twitter.com/share?text=#{CGI.escape(record.title)}&url=#{CGI.escape(link)}&hashtags=discursus"
    end],
    ['envelope', ->(record, link) { "mailto:?subject=#{CGI.escape(record.title)}&body=#{CGI.escape(link)}" }]
  ].freeze

  def share_icons_for(book)
    AVAILABLE_SHARE_ACTIONS.each do |icon, share_action|
      concat link_to(fa_stacked_icon("#{icon} inverse",
                                     base: 'stop 2x', class: 'dsc-book-share-icon fa-2x', target: '_blank'),
                     share_action.call(book, book_url(book)))
    end
  end

  def random_books(except_book = nil, limit = 4)
    Book.where.not(id: except_book&.id).where(is_available: true)
        .reorder('RANDOM(), books.published_at DESC').limit(limit)
  end

  def limited_author_names(author_names)
    return if author_names.blank?

    if author_names.size > 1
      tag.div(title: author_names.join(', ')) do
        t('books.author_and_others', author_name: author_names.first)
      end
    else
      tag.div { author_names.first }
    end
  end
end
