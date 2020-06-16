# frozen_string_literal: true

module RuboCop
  module Ducalis
    # Because RuboCop doesn't yet support plugins, we have to monkey patch in a
    # bit of our configuration.
    module Inject
      def self.defaults!
        path = ::Ducalis::DEFAULT_FILE.to_s
        hash = ConfigLoader.send(:load_yaml_configuration, path)
        config = Config.new(hash, path)
        puts "configuration from #{path}" if ConfigLoader.debug?
        config = ConfigLoader.merge_with_default(config, path, unset_nil: false)
        ConfigLoader.instance_variable_set(:@default_configuration, config)
      end
    end
  end
end
