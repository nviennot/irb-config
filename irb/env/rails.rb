module IRB::Env::Rails
  def self.switch_env(old_env, env)
    if ::Rails.env != env
      ENV['RAILS_ENV'] = env
      ::Rails.env = env

      Kernel.silence_warnings do
        Dir[Rails.root.join('config', 'initializers', '*.rb')].map do |file|
          load file
        end
        load "./config/environments/#{env}.rb"
      end
    end
  end

  IRB::Env.add_handler(self) if defined?(::Rails)
end
