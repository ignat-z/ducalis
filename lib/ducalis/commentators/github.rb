# frozen_string_literal: true

require 'ducalis/commentators/message'

module Ducalis
  module Commentators
    class Github
      STATUS = 'COMMENT'.freeze
      SIMILARITY_THRESHOLD = 0.8

      def initialize(repo, id)
        @repo = repo
        @id = id
      end

      def call(offenses)
        comments = offenses.reject { |offense| already_commented?(offense) }
                           .map { |offense| present_offense(offense) }

        return if comments.empty?

        Utils.ochokit
             .create_pull_request_review(@repo, @id,
                                         event: STATUS, comments: comments)
      end

      private

      def already_commented?(offense)
        current_offence = present_offense(offense)
        commented_offenses.find do |commented_offense|
          [
            current_offence[:path] == commented_offense['path'],
            current_offence[:position] == commented_offense['position'],
            similar_messages?(current_offence[:body], commented_offense['body'])
          ].all?
        end
      end

      def similar_messages?(message, body)
        body.include?(message) ||
          Utils.similarity(message, body) > SIMILARITY_THRESHOLD
      end

      def present_offense(offense)
        {
          body: Message.new(offense).with_link,
          path: diff_for(offense).path,
          position: diff_for(offense).patch_line(offense.line)
        }
      end

      def diff_for(offense)
        GitAccess.instance.for(offense.location.source_buffer.name)
      end

      def commented_offenses
        @commented_offenses ||= Utils.ochokit
                                     .pull_request_comments(@repo, @id).to_a
      end
    end
  end
end
