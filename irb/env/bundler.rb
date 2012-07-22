module IRB::Env::Bundler
  def self.switch_env(old_env, env)
    Bundler.require(env)
  end

  IRB::Env.add_handler(self) if defined?(::Bundler)
end
