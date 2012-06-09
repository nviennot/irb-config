module IRB
  module InteractiveRspecMongoid

    def self.setup
      return unless IRB.try_require 'interactive_rspec'

      InteractiveRspec.instance_eval do
        class << self
          alias_method :reconnect_active_record_orig, :reconnect_active_record

          def reconnect_active_record
            Mongoid.load!(Rails.root.join("config", "mongoid.yml"))
            reconnect_active_record_orig
            reload!
          end
        end
      end
    end

  end
end

IRB::InteractiveRspecMongoid.setup if defined?(Mongoid) and defined?(Rails)
