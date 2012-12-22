module IRB
  module RailsEnvSwitcher
    def self.setup
      return unless IRB.try_require 'rails-env-switcher'
      ::RailsEnvSwitcher::Pry.setup
    end
    setup if defined? ::Rails
  end
end
