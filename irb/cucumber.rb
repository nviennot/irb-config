module IRB
  module Cucumber
    def self.reset(args)
      require 'cucumber'
      require 'cucumber/rspec/disable_option_parser'
      require 'optparse'
      require 'cucumber'
      require 'logger'
      require 'cucumber/parser'
      require 'cucumber/feature_file'
      require 'cucumber/cli/configuration'

      # If we are using RSpec, make sure we load it before, because some step
      # definitions may contain some rspec wizardry.
      IRB::RSpec.reset if defined?(::RSpec)

      config = ::Cucumber::Cli::Configuration.new
      config.parse!(args)
      ::Cucumber.logger = config.log

      if @runtime
        def config.support_to_load
          begin
            load 'factory_girl/step_definitions.rb' if defined?(FactoryGirl)
          rescue LoadError
          end
          []
        end
        @runtime.configure(config)
      else
        @runtime = ::Cucumber::Runtime.new(config)
      end

      @runtime.instance_eval do
        @loader = nil
        @results = ::Cucumber::Runtime::Results.new(config)
        @support_code.instance_eval do
          @programming_languages.map do |programming_language|
            programming_language.step_definitions.clear
          end
        end
      end
    end

    def self.run(args)
      ::RailsEnvSwitcher.with_env('test', :reload => true) do
        self.reset(args)
        @runtime.run!
        @runtime.write_stepdefs_json
        @runtime.results.failure?
      end
    end

    def self.setup
      ::Pry::CommandSet.new do
        create_command "cucumber", "Works pretty much like the regular cucumber command" do
          group "Testing"
          def process(*args)
            IRB::Cucumber.run(args)
          end
        end
      end.tap { |cmd| ::Pry::Commands.import cmd }
    end

  end
end

IRB::Cucumber.setup
