module IRB::Env::Rails
  def self.switch_env(old_env, env)
    if ::Rails.env != env
      load "./config/environments/#{env}.rb"
      ENV['RAILS_ENV'] = env
      ::Rails.env = env
    end
  end

  IRB::Env.add_handler(self) if defined?(::Rails)
end
