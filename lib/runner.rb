# frozen_string_literal: true

require 'policial'

require './lib/custom_ruby'
require './lib/commentators/console'
require './lib/commentators/github'

class Runner
  def initialize(config)
    @config = config
    configure_policial
  end

  def call
    detective = Policial::Detective.new(octokit)
    detective.brief(commit_info)
    detective.investigate
    detective.violations.each do |violation|
      commentator.new(config, violation).call
    end
  end

  private

  attr_reader :config

  def commit_info
    { repo: config.repo, number: config.id, head_sha: config.sha }
  end

  def configure_policial
    Policial.style_guides = [CustomRuby]
  end

  def commentator
    @commentator ||= config.dry? ? Commentators::Console : Commentators::Github
  end

  def octokit
    @octokit ||= Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'))
  end
end
