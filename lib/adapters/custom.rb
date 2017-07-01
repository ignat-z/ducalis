module Adapters
  class Custom
    attr_reader :repo, :id, :sha

    def initialize(options)
      @repo = options.fetch(:repo)
      @id = options.fetch(:id)
      @sha = options.fetch(:sha)
    end
  end
end
