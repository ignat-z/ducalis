# frozen_string_literal: true

require 'rubocop'

module Ducalis
  DOTFILE = '.ducalis.yml'
  DUCALIS_HOME = File.realpath(File.join(File.dirname(__FILE__), '..'))
  DEFAULT_FILE = File.join(DUCALIS_HOME, 'config', DOTFILE)
end

require 'ducalis/version'
require 'ducalis/utils'
require 'ducalis/cli_arguments'
require 'ducalis/inject'

RuboCop::Ducalis::Inject.defaults!

Dir[File.join(Ducalis::DUCALIS_HOME, 'lib', 'ducalis', 'cops', '**', '*.rb')].sort.each do |file|
  require file
end
