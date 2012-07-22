module IRB::Env::ActiveRecord
  def self.switch_env(old_env, env)
    ::ActiveRecord::Base.clear_cache! if ::ActiveRecord::Base.respond_to? :clear_cache
    ::ActiveRecord::Base.clear_all_connections!
    ::ActiveRecord::Base.establish_connection
  end

  IRB::Env.add_handler(self) if defined?(::ActiveRecord::Base)
end
