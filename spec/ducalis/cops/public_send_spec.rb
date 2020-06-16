# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/public_send'

RSpec.describe Ducalis::PublicSend do
  subject(:cop) { described_class.new }

  it '[rule] raises if send method used in code' do
    inspect_source('user.send(action)')
    expect(cop).to raise_violation(/using `send`/)
  end

  it '[rule] better to use mappings for multiple actions' do
    inspect_source([
      '{',
      '  bark: ->(animal) { animal.bark },',
      '  meow: ->(animal) { animal.meow }',
      '}.fetch(actions)',
      '# or ever better',
      'animal.voice'
    ].join("\n"))
    expect(cop).not_to raise_violation
  end
end
