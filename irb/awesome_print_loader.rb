module IRB
  module AwesomePrintLoader

    def self.setup
      return unless IRB.try_require 'awesome_print'
      Pry.config.print = proc do |output, value|
        Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)
      end
    end

  end
end

IRB::AwesomePrintLoader.setup
