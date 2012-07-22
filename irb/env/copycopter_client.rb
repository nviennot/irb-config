module IRB::Env::CopycopterClient
  def self.switch_env(old_env, env)
    ::CopycopterClient::Rails.initialize
  end

  def self.setup
    conf = ::CopycopterClient.configuration
    def conf.environment_name
      ::Rails.env
    end

    ::CopycopterClient::RequestSync.class_eval do
      def call(env)
        @app.call(env)
      end
    end
  end

  IRB::Env.add_handler(self) if defined?(::CopycopterClient::Rails)
  setup if defined?(::CopycopterClient) && defined?(::Rails)
end
