# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class FetchExpression < RuboCop::Cop::Cop
    HASH_CALLING_REGEX = /\:\[\]/.freeze # params[:key]

    MSG = <<-MESSAGE.gsub(/^ +\|\s/, '').strip
      | You can use `fetch` instead.
      | If your hash contains `nil` or `false` values and you want to treat them not like an actual values you should preliminarily remove this values from hash.
      | You can use `compact` (in case if you do not want to ignore `false` values) or `keep_if { |key, value| value }` (if you want to ignore all `false` and `nil` values).
    MESSAGE

    def investigate(processed_source)
      return unless processed_source.ast

      matching_nodes(processed_source.ast).each do |node|
        add_offense(node)
      end
    end

    private

    def matching_nodes(ast)
      [
        *ternar_gets_present(ast).select(&method(:matching_ternar?)),
        *ternar_gets_nil(ast).select(&method(:matching_ternar?)),
        *default_gets(ast)
      ].uniq
    end

    def_node_search :default_gets, '(or (send (...) :[] (...)) (...))'
    def_node_search :ternar_gets_present, '(if (...) (send ...) (...))'
    def_node_search :ternar_gets_nil, '(if (send (...) :nil?) (...) (send ...))'

    def matching_ternar?(node)
      present_matching?(node) || nil_matching?(node)
    end

    def present_matching?(node)
      source, result, = *node
      (source == result && result.to_s =~ HASH_CALLING_REGEX)
    end

    def nil_matching?(node)
      source, _, result = *node
      (source.to_a.first == result && result.to_s =~ HASH_CALLING_REGEX)
    end
  end
end
