module IRB
  module BypassReloader
    def self.bypass_middleware(klass)
      klass.class_eval do
        def call(env)
          @app.call(env)
        end
      end
    end

    def self.setup
      # We are disabling the builtin reloader as we rely on manual reload! in
      # the console.
      return unless defined?(reload!)

      if defined?(ActionDispatch::Reloader)
        bypass_middleware ActionDispatch::Reloader
      elsif defined?(ActionDispatch::Callbacks)
        bypass_middleware ActionDispatch::Callbacks
      end
      if defined?(RailsDevTweaks::GranularAutoload::Middleware)
        bypass_middleware RailsDevTweaks::GranularAutoload::Middleware
      end
    end
    setup
  end
end
