# frozen_string_literal: true

require 'spec_helper'
require './lib/cops/keyword_defaults'

RSpec.describe Ducalis::KeywordDefaults do
  subject(:cop) { described_class.new }

  it 'rejects if method definition contains default values' do
    inspect_source(cop, 'def some_method(a, b, c = 3); end')
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it 'rejects if class method definition contains default values' do
    inspect_source(cop, 'def self.some_method(a, b, c = 3); end')
    expect(cop).to raise_violation(/keyword arguments/)
  end

  it 'works if method definition contains default values through keywords' do
    inspect_source(cop, 'def some_method(a, b, c: 3); end')
    expect(cop).to_not raise_violation
  end

  it 'works for methods without arguments' do
    inspect_source(cop, 'def some_method; end')
    expect(cop).to_not raise_violation
  end

  it 'works for class methods without arguments' do
    inspect_source(cop, 'def self.some_method; end')
    expect(cop).to_not raise_violation
  end
end
