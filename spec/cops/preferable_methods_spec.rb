# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/preferable_methods.rb'

RSpec.describe Ducalis::PreferableMethods do
  subject(:cop) { described_class.new }

  it 'raises for `delete` method calling' do
    inspect_source(cop, 'User.where(id: 7).delete')
    expect(cop).to raise_violation(/destroy/)
  end
end
