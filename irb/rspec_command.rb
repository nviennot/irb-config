module IRB
  module RSpecCommand

    def self.load_rspec
      return unless IRB.try_require 'interactive_rspec'
      require '~/.irb/irb/interactive_rspec_mongoid'

      if Gem.loaded_specs['rspec'].version < Gem::Version.new('2.9.10')
        raise 'Please use RSpec 2.9.10 or later'
      end
    end

    def self.config_cache
      require '~/.irb/irb/rspec_config_cache'
      @config_cache ||= RSpecConfigCache.new
    end

    def self.configure_rspec
      self.config_cache.cache do
        require Rails.root.join("spec", "spec_helper.rb")
        InteractiveRspec.configure
      end
      FactoryGirl.reload if defined?(FactoryGirl)
    end

    def self.with_rspec_env
      IRB::RSpecCommand.load_rspec
      InteractiveRspec.switch_rails_env do
        IRB::RSpecCommand.configure_rspec
        yield
      end
      RSpec.reset
    end

    def self.setup
      rspec_cmd = Pry::CommandSet.new do
        create_command "rspec", "Works pretty much like the regular rspec command" do
          group "RSpec"
          def process(specs)
            IRB::RSpecCommand.with_rspec_env do
              InteractiveRspec.run_specs(specs.to_s)
            end
          end
        end
      end

      Pry::Commands.import rspec_cmd
    end

  end
end

IRB::RSpecCommand.setup if defined?(Rails)
