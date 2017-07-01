require "policial"

require "./lib/custom_ruby"

class Runner
  def initialize(config)
    @config = config
    @octokit = Octokit::Client.new(access_token: ENV.fetch("GITHUB_TOKEN"))
    configure_policial
  end

  def call
    detective = Policial::Detective.new(octokit)
    detective.brief(repo: config.repo, number: config.id, head_sha: config.sha)
    detective.investigate
    detective.violations.each do |violation|
      octokit.create_pull_request_comment(*generate_comment(violation))
    end
  end

  private

  attr_reader :config, :octokit

  def configure_policial
    Policial.style_guides = [CustomRuby]
  end

  def generate_comment(violation)
    [
      config.repo,
      config.id,
      violation.message,
      config.sha,
      violation.filename,
      violation.line.patch_position
    ]
  end
end
