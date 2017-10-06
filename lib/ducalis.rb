# frozen_string_literal: true

module Ducalis
  DOTFILE = '.ducalis.yml'
end

require 'parser/current'
require 'policial'

require 'ducalis/adapters/base'
require 'ducalis/adapters/circle_ci'
require 'ducalis/adapters/custom'
require 'ducalis/adapters/pull_request'

require 'ducalis/commentators/console'
require 'ducalis/commentators/github'

require 'ducalis/cli'
require 'ducalis/passed_args'
require 'ducalis/runner'
require 'ducalis/utils'

require 'ducalis/cops/callbacks_activerecord'
require 'ducalis/cops/controllers_except'
require 'ducalis/cops/keyword_defaults'
require 'ducalis/cops/module_like_class'
require 'ducalis/cops/params_passing'
require 'ducalis/cops/private_instance_assign'
require 'ducalis/cops/protected_scope_cop'
require 'ducalis/cops/raise_withour_error_class'
require 'ducalis/cops/regex_cop'
require 'ducalis/cops/rest_only_cop'
require 'ducalis/cops/rubocop_disable'
require 'ducalis/cops/strings_in_activerecords'
require 'ducalis/cops/uncommented_gem'
require 'ducalis/cops/useless_only'

require 'ducalis/patched_rubocop/diffs'
require 'ducalis/patched_rubocop/git_files_access'
require 'ducalis/patched_rubocop/git_runner'
require 'ducalis/patched_rubocop/git_turget_finder'
require 'ducalis/patched_rubocop/rubo_cop'
