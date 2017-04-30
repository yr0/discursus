require 'rspec/expectations'

# checks if actual hash has keys from expected schema and if values of those keys are of expected kind
RSpec::Matchers.define :have_schema do |expected|
  match do |actual|
    expected.all? do |key, kind|
      actual.key?(key.to_s) && actual[key.to_s].is_a?(kind)
    end
  end
end

RSpec::Matchers.define :have_validation_error do |*expected|
  match do |actual|
    actual = actual.call if actual.is_a?(Proc)
    field, kind = expected
    actual.errors.details[field.to_sym].find { |e| e[:error] == kind.to_sym }.present?
  end

  failure_message do |actual|
    "expected that #{actual.errors.details} would contain #{expected}"
  end

  supports_block_expectations
end

RSpec::Matchers.define :be_equal_by do |field, expected|
  match do |actual|
    actual_ids = actual.map { |e| e[field.to_s] }
    expected_ids = expected.map { |e| e[field.to_s] }
    expected_ids.size == actual_ids.size && (expected_ids - actual_ids).blank?
  end
end

RSpec::Matchers.define :be_equal_by_ids_to do |expected|
  match do |actual|
    expect(expected).to be_equal_by :id, actual
  end
end

RSpec::Matchers.define :initiate_email_subjects do |*subjects|
  match do |actual|
    perform_enqueued_jobs(&actual)
    expect(ActionMailer::Base.deliveries.map(&:subject).map(&:strip)).to match_array subjects.map(&:strip)
  end

  match_when_negated do |actual|
    perform_enqueued_jobs(&actual)
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  failure_message do
    "Expected that mailer deliveries would initiate emails with subjects #{subjects}. "\
    "Instead got these subjects: #{ActionMailer::Base.deliveries.map(&:subject)}"
  end

  supports_block_expectations
end
