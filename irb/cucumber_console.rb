module IRB
  module CucumberConsole
    def self.setup
      return unless IRB.try_require 'cucumber-console'
      ::CucumberConsole::Pry.setup
    end
    setup
  end
end
