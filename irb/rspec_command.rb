module IRB
  module RSpecCommand

    def self.reload_rspec
      return unless IRB.try_require 'interactive_rspec'
      require '~/.irb/irb/interactive_rspec_mongoid'

      if Gem.loaded_specs['rspec'].version < Gem::Version.new('2.9.10')
        raise 'Please use RSpec 2.9.10 or later'
      end

      RSpec.reset
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

    def self.with_test_env(&block)
      return block.call if @test_env

      begin
        @test_env = true
        InteractiveRspec.switch_rails_env(&block)
      ensure
        @test_env = false
        reload!(false) if defined?(Mongoid) # also finalizes the mongodb database switch
      end
    end

    def self.with_rspec_env
      self.reload_rspec
      self.with_test_env do
        reload!(false)
        self.configure_rspec
        yield
      end
    end

    def self.setup
      rspec_cmd = Pry::CommandSet.new do
        create_command "rspec", "Works pretty much like the regular rspec command" do
          group "Testing"
          def process(specs)
            IRB::RSpecCommand.with_rspec_env do
              InteractiveRspec.run_specs(specs.to_s)
            end
          end
        end

        create_command "env", "Switch environment (only test for now). ctrl+d to leave" do
          group "Testing"
          def process(env)
            raise "Use only with argument 'test'" if env != 'test'
            IRB::RSpecCommand.with_rspec_env do
              TopLevel.new.pry
            end
          end
        end
      end

      Pry::Commands.import rspec_cmd
    end

  end
end

IRB::RSpecCommand.setup if defined?(Rails)
