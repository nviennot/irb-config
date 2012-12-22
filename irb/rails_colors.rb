module IRB
  module RailsLogger

    # Purple messages for Rails logger
    def self.setup
      require 'logger'
      Rails.logger = Logger.new(STDOUT)
      Rails.logger.formatter = proc do |severity, datetime, progname, msg|
        "\033[35m#{msg}\033[0m\n"
      end
    end

  end
end

IRB::RailsLogger.setup if defined?(Rails)
