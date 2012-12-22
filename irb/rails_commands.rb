module IRB
  module RailsCommands
    def self.setup
      return unless IRB.try_require 'commands'

      ::Pry::CommandSet.new do
        [:rake, :generate, :destroy, :update].each do |cmd|
          create_command cmd.to_s, "Works pretty much like the regular #{cmd} command" do
            group "Rails Commands"
            define_method(:process) do |*args|
              Commands.new.__send__(cmd, *args)
            end
          end
        end
      end.tap { |cmd| ::Pry::Commands.import cmd }
    end
    setup if defined? ::Rails::ConsoleMethods
  end
end
