# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/evlis_overusing'

RSpec.describe Ducalis::EvlisOverusing do
  subject(:cop) { described_class.new }

  it 'raises on multiple safe operator callings' do
    inspect_source('user&.person&.full_name')
    expect(cop).to raise_violation(/overusing/)
  end

  it '[rule] better to use NullObjects' do
    inspect_source([
      'class NullManufacturer',
      '  def contact',
      '    "No Manufacturer"',
      '  end',
      'end',
      '',
      'def manufacturer',
      '  product.manufacturer || NullManufacturer.new',
      'end',
      '',
      'manufacturer.contact'
    ].join("\n"))
    expect(cop).not_to raise_violation
  end

  it '[rule] raises on multiple try callings' do
    inspect_source('product.try(:manufacturer).try(:contact)')
    expect(cop).to raise_violation(/overusing/)
  end

  it 'raises on multiple try! callings' do
    inspect_source('product.try!(:manufacturer).try!(:contact)')
    expect(cop).to raise_violation(/overusing/)
  end

  it 'raises on multiple safe try callings' do
    inspect_source('params[:account].try(:[], :owner).try(:[], :address)')
    expect(cop).to raise_violation(/overusing/)
  end
end
