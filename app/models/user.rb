class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, omniauth_providers: %i(facebook google_oauth2)

  validates :name, :email, length: { maximum: 250 }
  has_many :orders, as: :customer, dependent: :nullify, inverse_of: :customer
  has_many :users_favorite_books, -> { where(is_favorited: true) }, inverse_of: :favorited_by_users
  has_many :favorite_books, through: :users_favorite_books, source: :book
  has_many :line_items, through: :orders

  bought_books_scope = lambda do
    where(orders: { aasm_state: :completed })
      .select('DISTINCT ON (books.id) books.*, array_agg(DISTINCT line_items.variant) AS bought_variants')
      .reorder('books.id ASC')
      .group('orders.updated_at, books.id')
  end
  has_many :bought_books, bought_books_scope, through: :line_items, source: :book

  def last_order
    orders.where.not(aasm_state: :pending).order(created_at: :desc).first
  end

  class << self
    def from_omniauth(request_data)
      find_or_initialize_by(oauth_provider: request_data.provider, oauth_uid: request_data.uid).tap do |user|
        if user.new_record?
          user.assign_attributes(name: request_data&.info&.name,
                                 email: request_data&.info&.email || "#{request_data.uid}@devnull",
                                 password: SecureRandom.hex(8))
          # fail silently if for example email exists or name is too long for now
          user.save
        end
      end
    end
  end
end
