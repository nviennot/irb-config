module IRB
  module RSpecConsole
    def self.setup
      return unless IRB.try_require 'rspec-console'
      ::RSpecConsole::Pry.setup
    end
    setup if defined? ::RSpec
  end
end
