module IRB::Env::Reloader
  def self.switch_env(old_env, env)
    if @@need_reload
      reload!(false) if respond_to?(:reload!)
      FactoryGirl.reload if defined?(FactoryGirl)
    end
    @@need_reload = false
  end

  @@need_reload = false
  def self.need_reload
    @@need_reload = true
  end

  IRB::Env.add_handler(self)
end

