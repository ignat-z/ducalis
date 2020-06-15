# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'

RSpec.describe Ducalis::Utils do
  describe '#similarity' do
    it 'returns 1 for equal strings' do
      expect(
        described_class.similarity('aaa', 'aaa')
      ).to be_within(0.01).of(1.0)
    end

    it 'returns 0 for fully different strings' do
      expect(
        described_class.similarity('aaa', 'zzz')
      ).to be_within(0.01).of(0)
    end

    it 'returns similarity score for strings' do
      expect(
        described_class.similarity('aabb', 'aazz')
      ).to be_within(0.01).of(0.5)
    end
  end

  describe '#silence_warnings' do
    it 'allows to change constants without warning' do
      SPEC_CONST = 1
      expect do
        described_class.silence_warnings { SPEC_CONST = 2 }
      end.to_not output.to_stderr
    end
  end
end
