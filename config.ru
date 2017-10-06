# frozen_string_literal: true

$LOAD_PATH.unshift("#{__dir__}/lib")
require 'ducalis'

require 'sinatra/base'
require 'sinatra'
require 'json'

post '/webhook' do
  options = JSON.parse(request.body.read)
  Thread.new do
    Runner.new(Adapters::PullRequest.new(options)).call
  end.abort_on_exception = true
  code 200
end

run Sinatra::Application
