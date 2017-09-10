# frozen_string_literal: true

require 'policial'

module Adapters
  class PullRequest < Base
    def repo
      @repo ||= attributes[:repo]
    end

    def id
      @id ||= attributes[:number]
    end

    def sha
      @sha ||= attributes[:head_sha]
    end

    private

    def attributes
      @attributes ||= Policial::PullRequestEvent.new(options)
                                                .pull_request_attributes
    end
  end
end
