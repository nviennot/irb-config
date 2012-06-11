module IRB
  module BypassReloader

    def self.setup
      ActionDispatch::Reloader.class_eval do
        def call(env)
          @app.call(env)
        end
      end
    end

  end
end

IRB::BypassReloader.setup if defined?(Rails)
