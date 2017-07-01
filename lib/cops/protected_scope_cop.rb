require "rubocop"

module RuboCop
  class ProtectedScopeCop < RuboCop::Cop::Cop
    def on_send(node)
      _, method_name, _ = *node
      return unless method_name == :find
      return unless children(node).any? { |node| node.type == :const }
      add_offense(node, :expression, "Dangerous Search!")
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
