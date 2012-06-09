module IRB
  module PryLoader

    def self.setup
      return unless IRB.try_require 'pry'

      Pry.prompt = [proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " },
                    proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]
      Pry.start
      exit
    end

  end
end

IRB::PryLoader.setup
