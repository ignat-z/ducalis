# frozen_string_literal: true

require './lib/utils'

module Adapters
  class Custom < Base
    def repo
      @repo ||= options.fetch(:repo)
    end

    def id
      @id ||= options.fetch(:id)
    end

    def sha
      @sha ||= options.fetch(:sha) do
        Utils.octokit.pull_request(repo, id).head.sha
      end
    end
  end
end
