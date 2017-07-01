# frozen_string_literal: true
require "rubocop"
require_relative "./callbacks_activerecord"

module RuboCop
  class StringsInActiverecords < ::RuboCop::Cop::Cop
    VALIDATEBLE_METHODS = ::RuboCop::CallbacksActiverecord::METHODS_BLACK_LIST + %i(
      validates
      validate
    )

    def on_send(node)
      _, method_name, *args = *node
      return unless VALIDATEBLE_METHODS.include?(method_name)
      return if args.empty?
      node.to_a.last.each_child_node do |current_node|
        key, value = *current_node
        next unless current_node.type == :pair
        next unless %w(if unless).include?(key.source)
        next unless value.type == :str
        add_offense(node, :selector, "Don't use string in validations and callbacks")
      end
    end
  end
end
