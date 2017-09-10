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
      @sha ||= options.fetch(:sha)
    end
  end
end
