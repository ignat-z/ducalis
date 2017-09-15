# frozen_string_literal: true

require 'logger'

module Commentators
  class Console
    DOCUMENTATION_PATH = 'https://github.com/ignat-zakrevsky/ducalis/blob/master/DOCUMENTATION.md'

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
        brown(@violation.linter),
        bold(ancor)
      ].join(' ')
    end

    def logger
      @logger ||= Logger.new(STDOUT).tap do |logger|
        logger.formatter = proc do |_severity, _datetime, _progname, msg|
          "#{msg}\n"
        end
      end
    end

    def ancor
      [
        DOCUMENTATION_PATH,
        '#',
        @violation.linter.downcase.gsub(/[^[:alpha:]]/, '')
      ].join
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
