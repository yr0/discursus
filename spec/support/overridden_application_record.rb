##
# Override base class for all models to use some methods suitable for testing
ApplicationRecord.class_eval do
  # check if errors contain given @field and if an error @kind is present on that field
  def _has_error?(field, kind)
    errors.details[field.to_sym].find { |e| e[:error] == kind.to_sym }
  end

  def _has_base_error?(kind)
    _has_error?(:base, kind)
  end
end
