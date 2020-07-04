##
# A note on variants. A book can have many variants (paperback, hardcover, ebook, audio), but we don't need
# to track the amount of books for each variant. Basically the variants only differ in price. Files for digital
# versions can easily be stored within one model. So we opted out of different table for variants and different models
# for each variant. The variants are stored in a postgres :json field structured as { variant_name => price }
# If we ever need to store the variants in different models, we can easily migrate to that structure leaving the json
# field to save the database queries where possible.
module VariantsFunctionality
  VARIANT_TYPES = %w(paperback hardcover ebook audio).freeze
  # Variants that can be bought only once
  VARIANTS_BOUGHT_ONCE = %w(ebook audio).freeze
  extend ActiveSupport::Concern

  included do
    before_save :update_price_from_variants, if: :available_variants_changed?
    validate :variants_must_contain_valid_data
  end

  module ClassMethods
    def variant_types
      VARIANT_TYPES
    end

    # Returns book only if it is found by id and if it's variant of +variant_type+ is available. Otherwise returns nil
    def fetch_if_available(id, variant_type)
      book = Book.find_by(id: id)
      book if book&.variant_available?(variant_type)
    end
  end

  def variant_available?(variant)
    return false if available_variants.blank?

    available_variants.key? variant.to_s
  end

  def price_of(variant)
    return 0.0 if available_variants.blank?

    available_variants[variant.to_s].to_f
  end

  # Transforms hash received from form into expected format, removing variants that are not defined and those
  # that have empty or zero price.
  # Example: { 'paperback' => { 'is_available' => 1, 'price' => 20.0 } }
  def variants=(variants_hash)
    variants = variants_hash.select do |k, v|
      v['is_available'].to_i.nonzero? && VARIANT_TYPES.include?(k)
    end
    self.available_variants = variants_with_float_prices(variants)
    self.is_available = available_variants.any?
  end

  private

  def variants_with_float_prices(variants)
    variants.map { |k, v| [k, v['price'].to_f] }.to_h
  end

  # [ validate ]
  def variants_must_contain_valid_data
    return unless available_variants.present?
    variants_must_contain_valid_types
    variant_prices_must_be_valid
    variants_must_contain_files
  end

  # validate if no extra variant keys have been added
  def variants_must_contain_valid_types
    errors.add(:base, :variants_invalid) if (available_variants.keys - VARIANT_TYPES).any?
  end

  # validate prices
  def variant_prices_must_be_valid
    errors.add(:base, :variants_price_invalid) if
        available_variants.values.any? { |price| price.negative? || price > 10_000 }
  end

  # validate files presence if available variants include ebook and audio
  def variants_must_contain_files
    if available_variants.key?('ebook') && ebook_file.blank? ||
       available_variants.key?('audio') && audio_file.blank?
      errors.add(:base, :variants_files_invalid)
    end
  end

  # [ before_save ]
  # sets main price for book from its first 'privileged' available variant
  def update_price_from_variants
    return if available_variants.blank?

    # available_variants is a hash, which does not have any kind of order.
    # We need to fetch first price respecting VARIANT_TYPES order
    VARIANT_TYPES.find { |vt| self.main_price = available_variants[vt] }
  end
end
