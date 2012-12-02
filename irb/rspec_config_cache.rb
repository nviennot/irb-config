module IRB
  #
  # We have to reset the RSpec.configuration, because it contains a lot of
  # information related to the current test (what's running, what are the
  # different test results, etc).
  #
  # RSpec.configuration gets also loaded with a bunch of stuff from the
  # 'spec/spec_helper.rb' file. Often that instance is extended with other
  # modules (FactoryGirl, Mocha,...) and we don't want to replace requires with
  # load all around the place.
  #
  # Instead, we cache whatever is done to RSpec.configuration during the
  # first invokration of require('spec_helper').
  # This is done by interposing the Proxy class on top of RSpec.configuration.
  #
  class RSpecConfigCache
    def initialize
      ::RSpec.instance_eval do
        def self.configuration=(value)
          @configuration = value
        end
      end
    end

    def cache
      if @proxy
        # replay
        ::RSpec.configure do |config|
          @recorded_config.each do |msg|
            config.send(msg[:method], *msg[:args], &msg[:block])
          end
        end
        ::RSpec.world.shared_example_groups.merge!(@shared_examples_groups)

      else
        # record
        real_config = ::RSpec.configuration
        @proxy = Proxy.new(@recorded_config = [], real_config)
        ::RSpec.configuration = @proxy
        yield
        ::RSpec.configuration = real_config
        @shared_examples_groups = ::RSpec.world.shared_example_groups.dup

        # rspec-rails/lib/rspec/rails/view_rendering.rb add methods on the
        # configuration singleton. Need advice to copy them without going down
        # the road with object2module.
      end

      # Well, instead of copying them, we redirect them to the configuration
      # proxy. Looks like it good enough.
      proxy = @proxy
      ::RSpec.configuration.define_singleton_method(:method_missing) do |method, *args, &block|
        proxy.send(method, *args, &block)
      end

    end
  end

  class Proxy
    def initialize(output, target)
      @output = output
      @target = target
    end

    [:include, :extend].each do |method|
      define_method(method) do |*args|
        method_missing(method, *args)
      end
    end

    def method_missing(method, *args, &block)
      @output << {:method => method, :args => args, :block => block}
      @target.send(method, *args, &block)
    end
  end
end
