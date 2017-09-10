# frozen_string_literal: true

require 'rubocop/rspec/support'
require 'rspec/expectations'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec::Matchers.define :raise_violation do |like|
  match do |cop|
    cop.offenses.size == 1 && cop.offenses.first.message.match(like)
  end

  match_when_negated do |cop|
    cop.offenses.empty?
  end
end
