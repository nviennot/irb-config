module IRB
  module Pry
    def self.setup
      return unless IRB.try_require 'pry'

      load_pry_plugins

      ::Pry.prompt = [proc { |obj, nest_level| "#{self.pwd} (#{obj}) > " },
                      proc { |obj, nest_level| "#{self.pwd} (#{obj}) * " }]
      @@home = Dir.home

      TopLevel.new.pry
      exit
    end

    def self.load_pry_plugins
      IRB.try_require 'pry-doc'
      IRB.try_require 'pry-git'
      IRB.try_require 'pry-rails'
      IRB.try_require 'pry-debugger'
      IRB.try_require 'pry-remote'
      IRB.try_require 'pry-stack_explorer'
      IRB.try_require 'pry-coolline'
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
