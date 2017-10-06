# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class RaiseWithourErrorClass < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode
    OFFENSE = %(
It's better to add exception class as raise argument. It will make easier to \
catch and process it later.
    ).strip

    def on_send(node)
      _who, what, *args = *node
      return if what != :raise
      return if args.first.type != :str
      add_offense(node, :expression, OFFENSE)
    end
  end
end
