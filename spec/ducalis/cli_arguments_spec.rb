# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cli_arguments'

RSpec.describe Ducalis::CliArguments do
  subject { described_class.new }

  describe '#docs_command?' do
    it 'return true if ARGV contains doc command' do
      stub_const('ARGV', ['--docs'])
      expect(subject.docs_command?).to be true
    end
  end

  describe '#help_command?' do
    it 'return true if ARGV contains any help command' do
      stub_const('ARGV', ['-h'])
      expect(subject.help_command?).to be true
    end
  end
end
