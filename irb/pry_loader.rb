module IRB
  module Pry
    def self.setup
      return unless IRB.try_require 'pry'

      ::Pry.prompt = [proc { |obj, nest_level| "(#{obj}) > " },
                      proc { |obj, nest_level| "(#{obj}) * " }]

      TopLevel.new.pry
      exit
    end
  end

  class TopLevel
    def to_s
      defined?(Rails) ? Rails.env : "main"
    end
    Object.__send__(:include, Rails::ConsoleMethods) if defined?(Rails::ConsoleMethods)
  end
end

IRB::Pry.setup
