module IRB
  module CopycopterClientEnv
    def self.setup
      if defined?(CopycopterClient) && defined?(Rails)
        conf = CopycopterClient.configuration
        def conf.environment_name
          Rails.env
        end

        CopycopterClient::RequestSync.class_eval do
          def call(env)
            @app.call(env)
          end
        end

      end
    end

  end
end

IRB::CopycopterClientEnv.setup
