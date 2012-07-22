module IRB::Env::Mongoid
  def self.switch_env(old_env, env)
    reconnect
  end

  def self.reconnect
    old_level = Mongoid.logger.level
    Mongoid.logger.level = Logger::WARN
    Mongoid.load!("./config/mongoid.yml")
    Mongoid.logger.level = old_level
    IRB::Env::Reloader.need_reload # finalizes the mongodb database switch
  end

  IRB::Env.add_handler(self) if defined?(::Mongoid)
end
