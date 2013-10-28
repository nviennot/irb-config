module IRB
  module Pry
    def self.setup
      return unless IRB.try_require 'pry'

      load_pry_plugins
      trap_winchange

      ::Pry.prompt = [proc { |obj, nest_level| "#{self.pwd} (#{obj}) > " },
                      proc { |obj, nest_level| "#{self.pwd} (#{obj}) * " }]
      @@home = Dir.home
    end

    def self.linux?
      require 'rbconfig'
      /linux/i === RbConfig::CONFIG["host_os"]
    end

    def self.load_pry_plugins
      IRB.try_require 'pry-doc'
      IRB.try_require 'pry-debugger'
    end

    def self.trap_winchange
      return unless linux? # mac crashes too often

      # thanks @rking
      trap :WINCH do
        size = `stty size`.split(/\s+/).map(&:to_i)
        Readline.set_screen_size(*size) rescue nil
        Readline.refresh_line
      end
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
