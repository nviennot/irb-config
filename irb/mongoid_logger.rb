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
        m = parse(msg)
        if m.nil?
          unless msg =~ /which could negatively impact client-side performance/
            old_formatter.call(severity, datetime, progname, msg)
          end
        else
          m[:query].gsub!(/BSON::ObjectId\('([^']+)'\)/, '0x\1')
          m[:duration] = m[:duration].split('.')[0] if m[:duration]

          line = "\033[1;32m☘ \033[1;37mMongoDB\033[0m "
          line << "(#{m[:duration]}ms) " if m[:duration]

          if m[:database]
            if m[:collection]
              line << colorize("[#{m[:database]}::#{m[:collection]}] ")
            else
              line << colorize("[#{m[:database]}] ")
            end
          end

          line << "#{colorize(m[:operation])} " if m[:operation]
          line << colorize(m[:query])
          line << "\n"
        end
      end
    end

    def self.colorize(msg)
      CodeRay.scan(msg, :ruby).term
    end

    def self.parse(msg)
      case msg
      when /^MONGODB \((.*)ms\) (.*)\['(.*)'\]\.(.*)$/
        {:duration => $1, :database => $2, :collection => $3, :query => $4}
      when /^MONGODB (.*)\['(.*)'\]\.(.*)$/
        {:database => $1, :collection => $2, :query => $3}
      when /^ *MOPED: (\S+:\S+) (\S+) +database=(\S+) collection=(\S+) (.*) \((.*)ms\)/
        {:host => $1, :operation => $2, :database => $3, :collection => $4, :query => $5, :duration => $6}
      when /^ *MOPED: (\S+:\S+) (\S+) +database=(\S+) (.*) \((.*)ms\)/
        {:host => $1, :operation => $2, :database => $3, :query => $4, :duration => $5}
      end
    end

  end
end

IRB::MongoidLogger.setup if defined?(Mongoid)
