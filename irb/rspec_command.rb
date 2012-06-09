module IRB
  module RSpecCommand

    def self.configure_rspec
      Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require(f) || load(f) }
      load Rails.root.join("spec", "spec_helper.rb")
      FactoryGirl.reload if defined?(FactoryGirl)
      InteractiveRspec.configure
    end

    def self.rspec(specs)
      return unless IRB.try_require 'interactive_rspec'
      require '~/.irb/irb/interactive_rspec_mongoid'

      if specs
        InteractiveRspec.switch_rails_env do
          IRB::RSpecCommand.configure_rspec
          InteractiveRspec.run_specs specs
        end
      else
        InteractiveRspec.switch_rspec_mode do
          InteractiveRspec.switch_rails_env do
            IRB::RSpecCommand.configure_rspec
            pry InteractiveRspec.new_extended_example_group
          end
        end
      end

      RSpec.reset
    end

    def self.setup
      rspec = Pry::CommandSet.new do
        create_command "rspec", "Launch rspec. Without arguments creates an rspec context (experimental)" do
          group "RSpec"
          def process(specs)
            IRB::RSpecCommand.rspec(specs)
            nil
          end
        end
      end
      Pry::Commands.import rspec
    end

  end
end

IRB::RSpecCommand.setup
