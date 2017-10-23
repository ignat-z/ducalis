# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/protected_scope_cop'

RSpec.describe Ducalis::ProtectedScopeCop do
  subject(:cop) { described_class.new }

  it 'raises if somewhere AR search was called on not protected scope' do
    inspect_source(cop, 'Group.find(8)')
    expect(cop).to raise_violation(/non-protected scope/)
  end

  it 'raises if AR search was called even for chain of calls' do
    inspect_source(cop, 'Group.includes(:some_relation).find(8)')
    expect(cop).to raise_violation(/non-protected scope/)
  end

  it 'ignores where statements and still raises error' do
    inspect_source(cop,
                   'Group.includes(:some_relation).where(name: "John").find(8)')
    expect(cop).to raise_violation(/non-protected scope/)
  end

  it 'ignores find method with passed block' do
    inspect_source(cop, 'MAPPING.find { |x| x == 42 }')
    expect(cop).to_not raise_violation
  end

  it 'ignores find method with passed multiline block' do
    inspect_source(cop, [
                     'MAPPING.find do |x|',
                     '  x == 42',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
