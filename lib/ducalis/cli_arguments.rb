# frozen_string_literal: true

module Ducalis
  class CliArguments
    HELP_FLAGS   = %w[-h -? --help].freeze
    DOCS_ARG     = :docs
    REPORTER_ARG = :reporter

    def docs_command?
      ARGV.any? { |arg| arg == to_key(DOCS_ARG) }
    end

    def help_command?
      ARGV.any? { |arg| HELP_FLAGS.include?(arg) }
    end

    def process!; end

    private

    def to_key(key)
      "--#{key}"
    end
  end
end
