# frozen_string_literal: true

require 'rubocop'

module Ducalis
  class UncommentedGem < ::RuboCop::Cop::Cop
    OFFENSE = %(
Please, add comment why are you including non-realized gem version for %<gem>s.
It will increase [bus-factor](<https://en.wikipedia.org/wiki/Bus_factor>).
    ).strip

    def investigate(processed_source)
      return unless processed_source.ast
      gem_declarations(processed_source.ast).select do |node|
        _, _, gemname, args = *node
        next if args.nil? || args.type == :str
        next if commented?(processed_source, node)
        add_offense(node, :selector,
                    format(OFFENSE, gem: gemname.loc.expression.source))
      end
    end

    private

    def_node_search :gem_declarations, '(send nil :gem str ...)'

    def commented?(processed_source, node)
      processed_source.comments
                      .map { |subnode| subnode.loc.line }
                      .include?(node.loc.line)
    end
  end
end
