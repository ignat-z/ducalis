# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class ProtectedScopeCop < RuboCop::Cop::Cop
    OFFENSE = %{
Seems like you are using `find` on non-protected scope. Potentially it could
lead to unauthorized access. It's better to call `find` on authorized resources
scopes. Example:

```ruby
current_group.employees.find(params[:id])
# better then
Employee.find(params[:id])
```
    }.strip

    def on_send(node)
      _, method_name, = *node
      return unless method_name == :find
      return unless children(node).any? { |subnode| subnode.type == :const }
      add_offense(node, :expression, OFFENSE)
    end

    private

    def children(node)
      current_nodes = [node]
      while current_nodes.any? { |subnode| subnode.child_nodes.count != 0 }
        current_nodes = current_nodes.flat_map do |subnode|
          subnode.child_nodes.count.zero? ? subnode : subnode.child_nodes
        end
      end
      current_nodes
    end
  end
end
