module IRB
  module GemLoader

    def self.setup
      # We make everything in the global gemset available, bypassing Bundler
      global_gemset = ENV['GEM_PATH'].split(':').grep(/ruby.*@global/).first
      Dir["#{global_gemset}/gems/*"].each { |p| $LOAD_PATH << "#{p}/lib" } if global_gemset
    end

  end

  def self.try_require(file)
    begin
      require file
      true
    rescue LoadError => e
      warn "=> Unable to load #{file}"
      false
    end
  end

end

IRB::GemLoader.setup if defined?(Bundler)
