# frozen_string_literal: true

require 'spec_helper'
require './lib/cops/useless_only.rb'

RSpec.describe Ducalis::UselessOnly do
  subject(:cop) { described_class.new }

  it 'raises for `before_filters` with only one method as array' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :do_something, only: [:index]',
                     '  def index; end',
                     '  private',
                     '  def do_something; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/inline/)
  end

  it 'raises for `before_filters` with only one method as keyword array' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :do_something, only: %i[index]',
                     '  def index; end',
                     '  private',
                     '  def do_something; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/inline/)
  end

  it 'raises for `before_filters` with many actions and only one method' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :do_something, :load_me, only: %i[index]',
                     '  def index; end',
                     '  private',
                     '  def do_something; end',
                     '  def load_me; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/inline/)
  end

  it 'raises for `before_filters` with only one method as argument' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :do_something, only: :index',
                     '  def index; end',
                     '  private',
                     '  def do_something; end',
                     'end'
                   ])
    expect(cop).to raise_violation(/inline/)
  end

  it 'ignores `before_filters` without arguments' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :do_something',
                     '  def index; end',
                     '  private',
                     '  def do_something; end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores `before_filters` with `only` and many arguments' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :do_something, only: %i[index show]',
                     '  def index; end',
                     '  def show; end',
                     '  private',
                     '  def do_something; end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores `before_filters` with `except` and one argument' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  before_filter :do_something, except: %i[index]',
                     '  def index; end',
                     '  private',
                     '  def do_something; end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
