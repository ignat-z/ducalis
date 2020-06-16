# frozen_string_literal: true

require 'rubocop'
require 'ducalis/cops/extensions/type_resolving'

module Ducalis
  class TooLongWorkers < RuboCop::Cop::Cop
    include RuboCop::Cop::ClassishLength
    prepend TypeResolving

    MSG = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | Seems like your worker is doing too much work, consider of moving business logic to service object. As rule, workers should have only two responsibilities:
      | - __Model materialization__: As async jobs working with serialized attributes it's nescessary to cast them into actual objects.
      | - __Errors handling__: Rescue errors and figure out what to do with them.
    MESSAGE

    def on_class(node)
      return unless in_worker?

      length = code_length(node)
      return unless length > max_length

      add_offense(node, message: "#{MSG} [#{length}/#{max_length}]")
    end
  end
end
