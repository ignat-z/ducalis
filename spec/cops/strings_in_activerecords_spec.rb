require 'spec_helper'
require './lib/cops/strings_in_activerecords'

RSpec.describe RuboCop::StringsInActiverecords do
  subject(:cop) { described_class.new }

  it 'doesnt raise for lambda if argument' do
    inspect_source(cop, 'validates :file, if: -> { remote_url.blank? }')
    expect(cop.offenses.size).to eq(0)
  end

  it 'raise for string if argument' do
    inspect_source(cop, "before_save :set_full_name, if: 'name_changed? || postfix_name_changed?'")
    expect(cop.offenses.size).to eq(1)
  end
end
