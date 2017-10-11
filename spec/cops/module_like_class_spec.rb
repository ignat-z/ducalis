# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/module_like_class'

RSpec.describe Ducalis::ModuleLikeClass do
  subject(:cop) { described_class.new }
  let(:cop_config) { { 'AllowedIncludes' => ['Singleton'] } }

  it 'raises if class doesn\'t contain constructor but accept the same args' do
    inspect_source([
                     'class MyClass',
                     '',
                     '  def initialize(customer)',
                     '    # ...',
                     '  end',
                     '',
                     '  def approve(task, estimate, some_args_1)',
                     '    # ...',
                     '  end',
                     '',
                     '  def decline(user, task, estimate, some_args_2)',
                     '    # ...',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def anything_you_want(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/pass `task`, `estimate` there/)
  end

  it 'raises for class with only one public method with args' do
    inspect_source([
                     'class MyClass',
                     '  def approve(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def anything_you_want(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/pass `task` there/)
  end

  it 'ignores classes with custom includes' do
    allow(cop).to receive(:cop_config).and_return(cop_config)
    inspect_source([
                     'class MyClass',
                     '  include Singleton',
                     '',
                     '  def approve(task)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores classes with inheritance' do
    inspect_source([
                     'class MyClass < AnotherClass',
                     '  def approve(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  private',
                     '',
                     '  def anything_you_want(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores classes with one method and initializer' do
    inspect_source([
                     'class MyClass',
                     '  def initialize(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  def call(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
