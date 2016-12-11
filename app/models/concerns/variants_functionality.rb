##
# A note on variants. A book can have many variants (paperback, hardcover, ebook, audio), but we don't need
# to track the amount of books for each variant. Basically the variants only differ in price. Files for digital
# versions can easily be stored within one model. So we opted out of different table for variants and different models
# for each variant. The variants are stored in a postgres :json field structured as { variant_name => price }
# If we ever need to store the variants in different models, we can easily migrate to that structure leaving the json
# field to save the database queries where possible.
module VariantsFunctionality
  VARIANT_TYPES = %w(paperback hardcover ebook audio).freeze
  extend ActiveSupport::Concern

  module ClassMethods
    def variant_types
      VARIANT_TYPES
    end
  end

  # Transforms hash received from form into expected format, removing variants that are not defined and those
  # that have empty or zero price
  def variants=(variants_hash)
    self.available_variants = variants_hash.select do |k, v|
      v['is_available'].to_i.nonzero? && VARIANT_TYPES.include?(k)
    end.map { |k, v| [k, v['price'].to_f] }.to_h
    self.is_available = available_variants.any?
  end

  private

  # [ validate ]
  def variants_must_contain_valid_data
    return unless available_variants.present?
    # validate if no extra variant keys have been added
    if (available_variants.keys - VARIANT_TYPES).any?
      errors.add(:base, :variants_invalid)
    end

    # validate prices
    if available_variants.values.any? { |price| price < 0 || price > 10_000 }
      errors.add(:base, :variants_price_invalid)
    end

    # validate files presence if available variants include ebook and audio
    if available_variants.keys.include?('ebook') && !ebook_file.present? ||
       available_variants.keys.include?('audio') && !audio_file.present?
      errors.add(:base, :variants_files_invalid)
    end
  end

  # [ before_save ]
  # sets main price for book from its first 'privileged' available variant
  def update_price_from_variants
    return unless available_variants.present?
    # available_variants is a hash, which does not have any kind of order.
    # We need to fetch first price respecting VARIANT_TYPES order
    VARIANT_TYPES.find { |vt| self.main_price = available_variants[vt] }
  end
end
