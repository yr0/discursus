class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable, #:omniauthable,
         :recoverable, :rememberable, :trackable, :validatable
end
