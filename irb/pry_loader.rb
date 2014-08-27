module IRB
  module Pry
    def self.setup
      return unless IRB.try_require 'pry'

      load_pry_plugins
      trap_winchange

      ::Pry.prompt = [proc { |obj, nest_level, pry| get_prompt(obj, nest_level, pry, ">") },
                      proc { |obj, nest_level, pry| get_prompt(obj, nest_level, pry, "|") }]
      @@home = Dir.home
    end

    def self.get_prompt(obj, nest_level, pry, suffix)
      obj_str = obj.inspect.gsub(/\n/, '')
      max_length = 20
      if obj_str.size > max_length+3
        obj_str = "#{obj_str[0, max_length/2]}...#{obj_str[-max_length/2..-1]}"
      end
      "#{self.pwd} (#{obj_str})#{":#{nest_level}" unless nest_level.zero?} #{suffix} "
    end

    def self.linux?
      require 'rbconfig'
      /linux/i === RbConfig::CONFIG["host_os"]
    end

    def self.load_pry_plugins
      IRB.try_require 'pry-doc'
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
    alias inspect to_s
    Object.__send__(:include, Rails::ConsoleMethods) if defined?(Rails::ConsoleMethods)
  end
end

IRB::Pry.setup
