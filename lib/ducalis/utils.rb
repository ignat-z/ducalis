# frozen_string_literal: true

require 'ducalis/commentators/ocho_kit'

module Ducalis
  module Utils
    module_function

    def ochokit
      @ochokit ||= begin
        token = ENV.fetch('GITHUB_TOKEN') { raise MissingToken }
        OchoKit.new(access_token: token)
      end
    end

    def similarity(string1, string2)
      longer = [string1.size, string2.size].max
      same = string1.each_char
                    .zip(string2.each_char)
                    .select { |char1, char2| char1 == char2 }
                    .size
      1 - (longer - same) / string1.size.to_f
    end

    def silence_warnings
      original_verbose = $VERBOSE
      $VERBOSE = nil
      yield
      $VERBOSE = original_verbose
    end
  end
end
