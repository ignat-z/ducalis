require "rubocop"

module RuboCop
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
    }

    def on_send(node)
      _, method_name, _ = *node
      return unless method_name == :find
      return unless children(node).any? { |node| node.type == :const }
      add_offense(node, :expression, OFFENSE)
    end

    private

    def children(node)
      current_nodes = [node]
      while current_nodes.any? { |node| node.child_nodes.count != 0 } do
        current_nodes = current_nodes.flat_map { |node| node.child_nodes.count == 0 ? node : node.child_nodes }
      end
      current_nodes
    end
  end
end
