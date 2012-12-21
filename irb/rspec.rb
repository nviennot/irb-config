module IRB
  module RSpec
    def self.reset
      require 'rspec'
      require '~/.irb/irb/rspec_config_cache'

      if Gem.loaded_specs['rspec'].version < Gem::Version.new('2.9.10')
        raise 'Please use RSpec 2.9.10 or later'
      end

      ::RSpec::Core::Runner.disable_autorun!
      ::RSpec::Core::Configuration.class_eval { define_method(:command) { 'rspec' } }
      ::RSpec.reset

      self.config_cache.cache do
        ::RSpec.configure do |config|
          if defined?(Mongoid)
            config.before do
              @logger_level = ::Mongoid.logger.level
              ::Mongoid.logger.level = Logger::WARN
            end
          end
          config.output_stream = STDOUT
          config.color_enabled = true
        end

        require "./spec/spec_helper"

        ::RSpec.configure do |config|
          if defined?(Mongoid)
            config.before do
              ::Mongoid.logger.level = @logger_level
            end
          end
        end
      end
    end

    def self.config_cache
      @config_cache ||= RSpecConfigCache.new
    end

    def self.run(args)
      ::RailsEnvSwitcher.with_env('test', :reload => true) do
        self.reset
        ::RSpec::Core::CommandLine.new(args).run(STDERR, STDOUT)
      end
    end

    def self.setup
      ::Pry::CommandSet.new do
        create_command "rspec", "Works pretty much like the regular rspec command" do
          group "Testing"
          def process(*args)
            IRB::RSpec.run(args)
          end
        end
      end.tap { |cmd| ::Pry::Commands.import cmd }
    end

  end
end

IRB::RSpec.setup
