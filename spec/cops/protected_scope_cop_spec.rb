# frozen_string_literal: true

require 'spec_helper'
require './lib/cops/protected_scope_cop'

RSpec.describe RuboCop::ProtectedScopeCop do
  subject(:cop) { described_class.new }

  it 'raise if somewhere AR search was called on not protected scope' do
    inspect_source(cop, 'Group.find(8)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'raise if AR search was called even for chain of calls' do
    inspect_source(cop, 'Group.includes(:some_relation).find(8)')
    expect(cop.offenses.size).to eq(1)
  end

  it 'works ignores where statements and still raises error' do
    inspect_source(cop,
                   'Group.includes(:some_relation).where(name: "John").find(8)')
    expect(cop.offenses.size).to eq(1)
  end
end
