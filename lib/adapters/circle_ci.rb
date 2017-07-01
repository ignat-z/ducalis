# frozen_string_literal: true

module Adapters
  class CircleCi
    def initialize(_); end

    def repo
      ENV.fetch('CIRCLE_REPOSITORY_URL').sub('https://github.com/', '')
    end

    def id
      ENV.fetch('CI_PULL_REQUEST')
         .sub("#{ENV.fetch('CIRCLE_REPOSITORY_URL')}/pull/", '')
    end

    def sha
      ENV.fetch('CIRCLE_SHA1')
    end
  end
end
