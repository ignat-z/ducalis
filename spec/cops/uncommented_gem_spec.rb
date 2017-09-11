# frozen_string_literal: true

require 'spec_helper'
require './lib/cops/uncommented_gem.rb'

RSpec.describe Ducalis::UncommentedGem do
  subject(:cop) { described_class.new }

  it 'raise for gem from github without comment' do
    inspect_source(cop, [
                     "gem 'a' ",
                     "gem 'b', '~> 1.3.1' ",
                     "gem 'c', git: 'https://github.com/c/c'"
                   ])
    expect(cop).to raise_violation(/add comment/)
  end

  it "doesn't raise for gem from github with comment" do
    inspect_source(cop, [
                     "gem 'a' ",
                     "gem 'b', '~> 1.3.1' ",
                     "gem 'c', git: 'https://github.com/c/c' # some description"
                   ])
    expect(cop).to_not raise_violation
  end
end
