require 'spec_helper'
require './lib/cops/regex_cop'

RSpec.describe RuboCop::RegexCop do
  subject(:cop) { described_class.new }

  it 'accepts matching constants' do
    inspect_source(cop, [
      'REGEX = /john/',
      'name = "john"',
      'puts "hi" if name =~ REGEX'
    ])
    expect(cop.offenses.size).to eq(0)
  end

  it 'raise if somewhere in code used regex which is not moved to const' do
    inspect_source(cop, [
      'name = "john"',
      'puts "hi" if name =~ /john/'
    ])
    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.first.message).to match(
      %r[puts "hi" if name =~ CONST_NAME])
  end

  it 'ignores named ruby constants' do
    inspect_source(cop, [
      'name = "john"',
      'puts "hi" if name =~ /[[:alpha:]]/'
    ])
    expect(cop.offenses.size).to eq(0)
  end

  it 'ignores dynamic regexs' do
    inspect_source(cop, [
      'name = "john"',
      'puts "hi" if name =~ /.{#{name.length}}/'
    ])
    expect(cop.offenses.size).to eq(0)
  end
end
