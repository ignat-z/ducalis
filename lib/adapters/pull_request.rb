require "policial"

module Adapters
  class PullRequest

    def initialize(attributes)
      event = Policial::PullRequestEvent.new(attributes)
      @attributes = event.pull_request_attributes
    end

    def repo
      attributes[:repo]
    end

    def id
      attributes[:number]
    end

    def sha
      attributes[:head_sha]
    end

    private
    attr_reader :attributes
  end
end
