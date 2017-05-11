module PersonalHelper
  PAGE_NAMES = {
      bookshelf: I18n.t('personal.nav.bookshelf'),
      orders: I18n.t('personal.nav.orders'),
      favorite_books: I18n.t('personal.nav.favorite'),
      profile: I18n.t('personal.nav.profile')
  }.freeze

  def current_personal_page
    PAGE_NAMES[controller_name.to_sym]
  end
end
