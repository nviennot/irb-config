module IRB
  module MongoidColors
    def self.setup
      return unless IRB.try_require 'coderay'
      require '~/.irb/irb/coderay_term'

      if defined?(::Mongoid)
        IRB.try_require 'mongoid-colors'
        Mongoid.logger = Rails.logger if defined?(::Rails)
      end
    rescue
    end
    setup
  end
end
