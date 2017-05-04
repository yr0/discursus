class TokensForDigitalBooksController < ApplicationController
  def show
    @token = TokenForDigitalBook.find_by!(code: params[:id])
  end

  def download
    token = TokenForDigitalBook.find_by!(code: params[:id])
    # increase download count!
    if token.ebook?
      send_file token.book.ebook_file.file
    elsif token.audio?
      send_file token.book.audio_file.file
    end
  end
end
