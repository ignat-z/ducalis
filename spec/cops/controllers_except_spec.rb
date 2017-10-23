# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/controllers_except.rb'

RSpec.describe Ducalis::ControllersExcept do
  subject(:cop) { described_class.new }

  it 'raises for `before_filters` with `except` method as array' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :something, except: [:index]',
                     '  def index; end',
                     '  def edit; end',
                     '  private',
                     '  def something; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/explicit/)
  end

  it 'raises for filters with many actions and only one `except` method' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :something, :load_me, except: %i[edit]',
                     '  def index; end',
                     '  def edit; end',
                     '  private',
                     '  def something; end',
                     '  def load_me; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/explicit/)
  end

  it 'ignores `before_filters` without arguments' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :something',
                     '  def index; end',
                     '  private',
                     '  def something; end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
