# frozen_string_literal: true

class PublicPdfUploader < PdfUploader
  def store_dir
    "public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def url(options = {})
    super(options).sub(%r{\A/public/}, '/')
  end
end
