module IRB
  module Pry
    def self.setup
      return unless IRB.try_require 'pry'

      ::Pry.prompt = [proc { |obj, nest_level| "#{self.pwd} (#{obj}) > " },
                      proc { |obj, nest_level| "#{self.pwd} (#{obj}) * " }]
      @@home = Dir.home

      TopLevel.new.pry
      exit
    end

    def self.pwd
      Dir.pwd.gsub(/^#{@@home}/, '~')
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
