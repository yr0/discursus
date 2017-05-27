class UsedTokenJob < ApplicationJob
  queue_as :default

  def perform(token_id)
    token = TokenForDigitalBook.find_by(id: token_id)
    token.update(is_used: true) if token.present?
  end
end
