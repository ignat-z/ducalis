# frozen_string_literal: true

module Ducalis
  module Adapters
    class CircleCi < Base
      def repo
        @repo ||= ENV.fetch('CIRCLE_REPOSITORY_URL')
                     .sub('https://github.com/', '')
                     .sub('git@github.com:', '')
      end

      def id
        @id ||= ENV.fetch('CI_PULL_REQUEST')
                   .sub("#{ENV.fetch('CIRCLE_REPOSITORY_URL')}/pull/", '')
      end

      def sha
        @sha ||= ENV.fetch('CIRCLE_SHA1')
      end
    end
  end
end
