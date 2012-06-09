# encoding: utf-8
module IRB
  module MongoidLogger

    # Mongoid pretty prints its command, colorized with coderay
    def self.setup
      Mongoid.logger = Rails.logger if defined?(Rails)

      return unless IRB.try_require 'coderay'
      require '~/.irb/irb/coderay_term'

      old_formatter = Mongoid.logger.formatter
      Mongoid.logger.formatter = proc do |severity, datetime, progname, msg|
        m = msg.match(/^MONGODB \(([^)]*)\) (.*)$/)
        if m.nil?
          unless msg =~ /which could negatively impact client-side performance/
            old_formatter.call(severity, datetime, progname, msg)
          end
        else
          duration = m[1]
          command = m[2]
          command.gsub!(/BSON::ObjectId\('([^']+)'\)/, '0x\1')
          "\033[1;32m☘ \033[1;37mMongoDB\033[0m #{duration} #{CodeRay.scan(command, :ruby).term}\n"
        end
      end
    end

  end
end

IRB::MongoidLogger.setup if defined?(Mongoid)
