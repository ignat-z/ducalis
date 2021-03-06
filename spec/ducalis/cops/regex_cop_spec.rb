# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/regex_cop'

RSpec.describe Ducalis::RegexCop do
  subject(:cop) { described_class.new }

  it '[rule] raises if somewhere used regex which is not moved to const' do
    inspect_source([
                     'name = "john"',
                     'puts "hi" if name =~ /john/'
                   ])

    expect(cop).to raise_violation(%r{CONST_NAME = /john/ # "john"})
    expect(cop).to raise_violation(/puts "hi" if name =~ CONST_NAME/)
  end

  it '[rule] better to move regexes to constants with examples' do
    inspect_source([
                     'FOUR_NUMBERS_REGEX = /\d{4}/ # 1234',
                     'puts "match" if number =~ FOUR_NUMBERS_REGEX'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'raises if somewhere in code used regex but defined another const' do
    inspect_source([
                     'ANOTHER_CONST = /ivan/',
                     'puts "hi" if name =~ /john/'
                   ])
    expect(cop).to raise_violation(/puts "hi"/)
  end

  it 'ignores matching constants' do
    inspect_source([
                     'REGEX = /john/',
                     'name = "john"',
                     'puts "hi" if name =~ REGEX'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores named ruby constants' do
    inspect_source([
                     'name = "john"',
                     'puts "hi" if name =~ /[[:alpha:]]/'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores dynamic regexes' do
    inspect_source([
                     'name = "john"',
                     'puts "hi" if name =~ /.{#{' + 'name.length}}/'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'rescue dynamic regexes dynamic regexes' do
    inspect_source([
                     'name = "john"',
                     'puts "hi" if name =~ /foo(?=bar)/'
                   ])
    expect(cop).to raise_violation(
      %r{CONST_NAME = /foo\(\?=bar\)/ # "some_example"}
    )
  end
end
