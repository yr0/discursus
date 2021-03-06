# frozen_string_literal: true

class TokensForDigitalBooksController < ApplicationController
  def show
    @token = TokenForDigitalBook.find_by!(code: params[:id])
    @book = @token.book
  end

  def download
    @token = TokenForDigitalBook.unused.find_by!(code: params[:id])
    @token.schedule_used_flag
    send_file_from_token
  end

  private

  def send_file_from_token
    if @token.ebook?
      send_file @token.book.ebook_file.path
    elsif @token.audio?
      send_file @token.book.audio_file.path
    end
  end
end
