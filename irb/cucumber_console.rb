module IRB
  module CucumberConsole
    def self.setup
      return unless IRB.try_require 'cucumber-console'
      ::CucumberConsole::Pry.setup
    end
    setup if defined?(::Cucumber)
  end
end
