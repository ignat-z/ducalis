# frozen_string_literal: true

require 'logger'

module Commentators
  class Console
    RUBY_SNIPPET = /```ruby\n(?<code>.+)\n```/m
    def initialize(config, violation)
      @config = config
      @violation = violation
    end

    def call
      logger.info(message)
    end

    private

    def message
      [
        [cyan(@violation.filename), @violation.line.patch_position].join(':'),
        ' -- ',
        brown(@violation.linter),
        "\n",
        format_code(@violation.message)
      ].join
    end

    def logger
      @logger ||= Logger.new(STDOUT).tap do |logger|
        logger.formatter = proc do |_severity, _datetime, _progname, msg|
          "#{msg}\n"
        end
      end
    end

    def format_code(message)
      match_data = message.match(RUBY_SNIPPET)
      return message unless match_data
      message.sub(RUBY_SNIPPET, bold(match_data[:code]))
    end

    def bold(text)
      "\e[1m#{text}\e[22m"
    end

    def brown(text)
      "\e[33m#{text}\e[0m"
    end

    def cyan(text)
      "\e[36m#{text}\e[0m"
    end
  end
end
