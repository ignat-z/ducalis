# frozen_string_literal: true

module Commentators
  class Github
    def initialize(config, violation)
      @config = config
      @violation = violation
    end

    def call
      octokit.create_pull_request_comment(*generate_comment)
    end

    private

    def octokit
      @octokit ||= Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'))
    end

    def generate_comment
      [
        @config.repo,
        @config.id,
        @violation.message,
        @config.sha,
        @violation.filename,
        @violation.line.patch_position
      ]
    end
  end
end
