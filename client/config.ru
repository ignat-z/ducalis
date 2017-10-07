# frozen_string_literal: true

require 'ducalis'
require 'sinatra/base'
require 'sinatra'
require 'json'

post '/webhook' do
  options = JSON.parse(request.body.read)
  Thread.new do
    Ducalis::Runner.new(Ducalis::Adapters::PullRequest.new(options)).call
  end
  status 200
end

run Sinatra::Application
