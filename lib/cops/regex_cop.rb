# frozen_string_literal: true
require "rubocop"

module RuboCop
  class RegexCop < RuboCop::Cop::Cop
    SELF_DESCRIPTIVE = %w(
      /[[:alnum:]]/
      /[[:alpha:]]/
      /[[:blank:]]/
      /[[:cntrl:]]/
      /[[:digit:]]/
      /[[:graph:]]/
      /[[:lower:]]/
      /[[:print:]]/
      /[[:punct:]]/
      /[[:space:]]/
      /[[:upper:]]/
      /[[:xdigit:]]/
      /[[:word:]]/
      /[[:ascii:]]/
    )

    def on_regexp(node)
      return if node.parent.type == :casgn
      return if SELF_DESCRIPTIVE.include?(node.source)
      return if node.child_nodes.any? { |child_node| child_node.type == :begin }
      add_offense(node, :expression, "It's better to move regexs to constant with example")
    end
  end
end
