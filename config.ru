# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra'
require 'json'

require './lib/runner'
require './lib/adapters/base'
require './lib/adapters/pull_request'

post '/webhook' do
  options = JSON.parse(request.body.read)
  Thread.new do
    Runner.new(Adapters::PullRequest.new(options)).call
  end.abort_on_exception = true
  return 200
end

run Sinatra::Application
