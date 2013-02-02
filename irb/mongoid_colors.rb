module IRB
  module MongoidColors
    def self.setup
      return unless IRB.try_require 'coderay'
      require '~/.irb/irb/coderay_term'

      if defined?(::Mongoid)
        Moped.logger = Mongoid.logger = Rails.logger if defined?(::Rails)
        IRB.try_require 'mongoid-colors'
      end
    rescue
    end
    setup
  end
end
