module IRB
  module RSpec

    def self.reload_rspec
      if Gem.loaded_specs['rspec'].version < Gem::Version.new('2.9.10')
        raise 'Please use RSpec 2.9.10 or later'
      end

      ::RSpec.reset
    end

    def self.config_cache
      require '~/.irb/irb/rspec_config_cache'
      @config_cache ||= RSpecConfigCache.new
    end

    def self.mute_logger_before_test
      ::RSpec.configure do |config|
        config.before do
          @logger_level = Rails.logger.level
          Rails.logger.level = Logger::WARN
        end
      end
      yield
      ::RSpec.configure do |config|
        config.before do
          Rails.logger.level = @logger_level
        end
      end
    end

    def self.configure_rspec
      self.config_cache.cache do
        self.mute_logger_before_test do
          require Rails.root.join("spec", "spec_helper.rb")
          InteractiveRspec.configure
        end
      end
      FactoryGirl.reload if defined?(FactoryGirl)
    end

    def self.with_rspec_env
      self.reload_rspec
      RailsEnv.with_test_env do
        reload!(false)
        self.configure_rspec
        yield
      end
    end

    def self.cucumber_config(args)
      @cucumber_config = Cucumber::Cli::Configuration.new
      @cucumber_config.parse!(args)
      Cucumber.logger = @cucumber_config.log
      @cucumber_config
    end

    def self.with_cucumber_env(args)
      self.with_rspec_env do
        require 'cucumber'
        require 'cucumber/rspec/disable_option_parser'
        require 'optparse'
        require 'cucumber'
        require 'logger'
        require 'cucumber/parser'
        require 'cucumber/feature_file'
        require 'cucumber/cli/configuration'

        existing_runtime = @cuc_runtime
        runtime = if existing_runtime
          config = self.cucumber_config(args)
          def config.support_to_load
            load 'factory_girl/step_definitions.rb' if defined?(FactoryGirl)
            []
          end
          existing_runtime.configure(config)
          existing_runtime
        else
          @cuc_runtime = Cucumber::Runtime.new(self.cucumber_config(args))
        end
        runtime.instance_eval do
          @loader = nil
          @results = Cucumber::Runtime::Results.new(@configuration)
          @support_code.instance_eval do
            @programming_languages.map do |programming_language|
              programming_language.step_definitions.clear
            end
          end
        end

        runtime.run!
        runtime.write_stepdefs_json
        runtime.results.failure?
      end
    end

    def self.setup
      ::Pry::CommandSet.new do
        create_command "cucumber", "Works pretty much like the regular cucumber command" do
          group "Testing"
          def process(*args)
            IRB::RSpec.with_cucumber_env(args) do
              TopLevel.new.pry
            end
          end
        end
        create_command "rspec", "Works pretty much like the regular rspec command" do
          group "Testing"
          def process(specs)
            IRB::RSpec.with_rspec_env do
              InteractiveRspec.run_specs(specs.to_s)
            end
          end
        end
      end.tap { |cmd| ::Pry::Commands.import cmd }
    end

  end
end

IRB::RSpec.setup if defined?(Rails)
