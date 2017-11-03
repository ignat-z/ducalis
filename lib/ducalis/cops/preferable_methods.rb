# frozen_string_literal: true
require 'rubocop'

module Ducalis
  class PreferableMethods < RuboCop::Cop::Cop
    OFFENSE = %(
Prefer to use %<alternative>s method instead of %<original>s because of
%<reason>s.
    ).strip
    DESCRIPTION = {
      # Method => [Alternative, Reason]
      delete_all: [:destroy_all, 'it is not invoking callbacks'],
      delete: [:destroy, 'it is not invoking callbacks']
    }.freeze

    def on_send(node)
      _who, what, *_args = *node
      return unless DESCRIPTION.keys.include?(what)
      alternative, reason = DESCRIPTION.fetch(what)
      add_offense(node, :expression, format(OFFENSE, original: what,
                                                     alternative: alternative,
                                                     reason: reason))
    end
  end
end
