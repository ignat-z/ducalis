# frozen_string_literal: true

require 'spec_helper'
require './lib/cops/keyword_defaults'

RSpec.describe Ducalis::KeywordDefaults do
  subject(:cop) { described_class.new }

  it 'rejects ActiveRecord classes which contains callbacks' do
    inspect_source(cop, 'def some_method(a, b, c = 3); end')
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it 'ignores non-ActiveRecord classes which contains callbacks' do
    inspect_source(cop, 'def some_method(a, b, c: 3); end')
    expect(cop).to_not raise_violation
  end

  it 'works for methods without arguments' do
    inspect_source(cop, 'def some_method; end')
    expect(cop).to_not raise_violation
  end
end
