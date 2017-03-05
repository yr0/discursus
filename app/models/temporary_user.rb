# User that is created for session of unregistered customer. Must be deleted after some time of inactivity
class TemporaryUser < ApplicationRecord
  # temp user can only track 1 order at a time - provide logic for it
  has_many :orders, as: :customer, dependent: :destroy
  before_create :add_uuid

  private

  def add_uuid
    self.uuid ||= SecureRandom.uuid
  end
end