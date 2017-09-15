# frozen_string_literal: true

module Adapters
  class Custom < Base
    def repo
      @repo ||= options.fetch(:repo)
    end

    def id
      @id ||= options.fetch(:id)
    end

    def sha
      @sha ||= options.fetch(:sha) { octokit.pull_request(repo, id).head.sha }
    end

    private

    def octokit
      @octokit ||= Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'))
    end
  end
end
