# frozen_string_literal: true

require 'spec_helper'
require './lib/cops/rest_only_cop.rb'

RSpec.describe RuboCop::RestOnlyCop do
  subject(:cop) { described_class.new }

  it 'raise for controllers with non-REST methods' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  def index; end',
                     '  def non_rest_method; end',
                     'end'
                   ])
    expect(cop.offenses.size).to eq(1)
    expect(cop.offenses.first.message).to match(/REST/)
  end

  it "doesn't raise for controllers with private non-REST methods" do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  def index; end',
                     '  private',
                     '  def non_rest_method; end',
                     'end'
                   ])
    expect(cop.offenses.size).to eq(0)
  end

  it "doesn't raise for controllers with only REST methods" do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  def index; end',
                     '  def show; end',
                     '  def new; end',
                     '  def edit; end',
                     '  def create; end',
                     '  def update; end',
                     '  def destroy; end',
                     'end'
                   ])
    expect(cop.offenses.size).to eq(0)
  end

  it "doesn't raise for non-controllers with non-REST methods" do
    inspect_source(cop, [
                     'class MyClass',
                     '  def index; end',
                     '  def non_rest_method; end',
                     'end'
                   ])
    expect(cop.offenses.size).to eq(0)
  end
end
