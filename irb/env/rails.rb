module IRB::Env::Rails
  def self.switch_env(old_env, env)
    load "./config/environments/#{env}.rb"
    ENV['RAILS_ENV'] = env
    ::Rails.env = env
  end

  IRB::Env.add_handler(self) if defined?(::Rails)
end
