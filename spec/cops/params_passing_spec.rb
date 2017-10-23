# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/params_passing'

RSpec.describe Ducalis::ParamsPassing do
  subject(:cop) { described_class.new }

  it 'raises if user pass `params` as argument from controller' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  def index',
                     '    MyService.new(params).call',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/preprocessed params/)
  end

  it 'raises if user pass `params` as any argument from controller' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  def index',
                     '    MyService.new(first_arg, params).call',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/preprocessed params/)
  end

  it 'raises if user pass `params` as keyword argument from controller' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  def index',
                     '    MyService.new(first_arg, any_name: params).call',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/preprocessed params/)
  end

  it 'ignores passing only one `params` field' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  def index',
                     '    MyService.new(first_arg, params[:id]).call',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores passing processed `params`' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  def index',
                     '    MyService.new(first_arg, params.slice(:name)).call',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores passing `params` from `arcane` gem' do
    inspect_source(cop, [
                     'class MyController < ApplicationController',
                     '  def index',
                     '    MyService.new(params.for(Log).as(user).refine).call',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end
end
