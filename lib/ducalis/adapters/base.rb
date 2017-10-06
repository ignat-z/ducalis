# frozen_string_literal: true

module Ducalis
  module Adapters
    class Base
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def dry?
        @dry ||= @options.fetch(:dry, false)
      end
    end
  end
end
