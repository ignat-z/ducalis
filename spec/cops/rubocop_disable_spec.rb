# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/rubocop_disable'

RSpec.describe Ducalis::RubocopDisable do
  subject(:cop) { described_class.new }

  it 'raises on RuboCop disable comments' do
    inspect_source([
                     '# rubocop:disable Metrics/ParameterLists',
                     'def some_method(a, b, c, d, e, f); end'
                   ])
    expect(cop).to raise_violation(/RuboCop/)
  end

  it 'doesnt raise on comment without RuboCop disabling' do
    inspect_source([
                     '# some meaningful comment',
                     'def some_method(a, b, c, d, e, f); end'
                   ])
    expect(cop).to_not raise_violation
  end
end
