# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class PrivateInstanceAssign < RuboCop::Cop::Cop
    include RuboCop::Cop::DefNode

    OFFENSE = %(
Please, don't assign instance variables in controller's private methods. It's \
make hard to understand what variables are available in views.
).strip
    ADD_OFFENSE = %(
If you want to memoize variable, please, add underscore to the variable name \
start: `@_name`.
).strip
    def on_class(node)
      _classdef_node, superclass, _body = *node
      return if superclass.nil?
      @triggered = superclass.loc.expression.source =~ /Controller/
    end

    def on_ivasgn(node)
      return unless triggered
      return unless non_public?(node)
      return check_memo(node) if node.parent.type == :or_asgn
      add_offense(node, :expression, OFFENSE)
    end

    private

    def check_memo(node)
      return if node.to_a.first.to_s.start_with?('@_')
      add_offense(node, :expression, [OFFENSE, ADD_OFFENSE].join(' '))
    end

    attr_reader :triggered
  end
end
