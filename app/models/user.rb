class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, omniauth_providers: %i(facebook google_oauth2)

  validates :name, :email, length: { maximum: 250 }
  has_many :orders, as: :customer
  has_many :users_favorite_books
  has_many :favorite_books, through: :users_favorite_books, source: :book
  has_many :line_items, through: :orders
  has_many :bought_books,
           -> { where(orders: { aasm_state: :completed })
                    .select('DISTINCT ON (books.id) books.*')
                    .reorder('books.id ASC')
                    .group('orders.updated_at, books.id') },
           through: :line_items, source: :book

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
