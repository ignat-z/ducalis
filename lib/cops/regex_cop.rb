# frozen_string_literal: true
require "rubocop"

module RuboCop
  class RegexCop < RuboCop::Cop::Cop
    OFFENSE = %{
It's better to move regex to constants with example instead of direct using it.
It will allow you to reuse this regex and provide instructions for others.

```ruby
CONST_NAME = %{constant} # "matching_string_example"
%{fixed_string}
```
    }
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
      add_offense(node, :expression, OFFENSE % {
        constant: node.source,
        fixed_string: node.source_range.source_line.sub(node.source, 'CONST_NAME').lstrip
      })
    end
  end
end
