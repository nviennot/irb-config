module IRB
  module Env
    @@env = defined?(::Rails) ? ::Rails.env : "development"
    def self.with_env(env)
      return yield if @@env == env
      old_env = @@env

      # Not using ActiveSupport callbacks because the order matters.
      @@handlers.reverse.reduce(proc { yield }) do |chain, handler|
        proc do
          handler.switch_env(old_env, env)
          begin
            chain.call
          ensure
            handler.switch_env(env, old_env)
          end
        end
      end.call
    end

    def self.switch_env(old_env, env)
      @@env = env
    end

    @@handlers = []
    def self.add_handler(handler)
      @@handlers << handler
    end

    def self.setup(*handlers)
      ::Pry::CommandSet.new do
        create_command "env", "Switch environment. ctrl+d to leave" do
          group "Environment"
          def process(env)
            IRB::Env.with_env(env) do
              TopLevel.new.pry
            end
          end
        end
      end.tap { |cmd| ::Pry::Commands.import cmd }
    end

    # The order matters: handlers are executed top to bottom when switching env
    load '~/.irb/irb/env/bundler.rb'
    load '~/.irb/irb/env/reloader.rb'
    load '~/.irb/irb/env/rails.rb'
    load '~/.irb/irb/env/active_record.rb'
    load '~/.irb/irb/env/mongoid.rb'
    load '~/.irb/irb/env/copycopter_client.rb'
    load '~/.irb/irb/env/reloader.rb'

    IRB::Env.add_handler(self)
    Env.setup if @@handlers.size > 1
  end
end

