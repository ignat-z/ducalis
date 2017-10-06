# frozen_string_literal: true

require './lib/utils'
require './lib/patched_rubocop/git_files_access'
require './lib/patched_rubocop/git_turget_finder'
require './lib/patched_rubocop/git_runner'

module RuboCop
  class ConfigLoader
    Utils.silence_warnings { DOTFILE = '.customcop.yml' }
  end

  class TargetFinder
    prepend PatchedRubocop::GitTurgetFinder
  end

  class Runner
    prepend PatchedRubocop::GitRunner
  end
end

module PatchedRubocop
  MODES = {
    branch: ->(git)  { git.diff('origin/master') },
    index:  ->(git)  { git.diff('HEAD') },
    all:    ->(_git) { [] }
  }.freeze

  module_function

  def configure!(flag)
    GitFilesAccess.instance.flag = flag
  end
end