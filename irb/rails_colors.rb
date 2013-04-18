module IRB
  module RailsLogger
    # Cyan messages for Rails logger
    def self.setup
      require 'logger'
      Rails.logger = Logger.new(STDERR)
      Rails.logger.level = Logger::INFO
      Rails.logger.formatter = proc do |severity, datetime, progname, msg|
        "\033[36m#{msg}\033[0m\n"
      end
    rescue
    end
    setup if defined? ::Rails
  end
end
