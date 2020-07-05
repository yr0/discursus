# frozen_string_literal: true

module Sluggable
  def should_generate_new_friendly_id?
    new_record? || slug.blank? || send("#{friendly_id_config.base}_changed?")
  end

  def normalize_friendly_id(text)
    text.to_slug.normalize(transliterations: :ukrainian).to_s
  end

  def resolve_friendly_id_conflict(candidates)
    "#{candidates.first}#{friendly_id_config.sequence_separator}#{self.class.maximum(:id) + 1}"
  end
end
