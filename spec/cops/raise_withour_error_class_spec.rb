# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/raise_withour_error_class'

RSpec.describe Ducalis::RaiseWithourErrorClass do
  subject(:cop) { described_class.new }

  it 'raises when `raise` called without exception class' do
    inspect_source(cop, 'raise "Something went wrong"')
    expect(cop).to raise_violation(/exception class/)
  end

  it 'ignores when `raise` called with exception class' do
    inspect_source(cop, 'raise StandardError, "Something went wrong"')
    expect(cop).to_not raise_violation
  end

  it 'ignores when `raise` called with exception instance' do
    inspect_source(cop, 'raise StandardError.new("Something went wrong")')
    expect(cop).to_not raise_violation
  end
end
