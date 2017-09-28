# frozen_string_literal: true

require 'policial'

require './lib/custom_ruby'
require './lib/commentators/console'
require './lib/commentators/github'

class Runner
  def initialize(config)
    @config = config
    configure
  end

  def call
    detective = Policial::Detective.new(octokit)
    detective.brief(commit_info)
    detective.investigate
    commentator.new(config).call(detective.violations)
  end

  private

  attr_reader :config

  def commit_info
    { repo: config.repo, number: config.id, head_sha: config.sha }
  end

  def configure
    Octokit.auto_paginate = true
    Policial.linters = [CustomRuby]
  end

  def commentator
    @commentator ||= config.dry? ? Commentators::Console : Commentators::Github
  end

  def octokit
    @octokit ||= Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'))
  end
end
