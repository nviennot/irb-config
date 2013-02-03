module IRB
  module GemLoader
    def self.setup
      if defined?(Bundler)
        # We make everything in the global gemset available, bypassing Bundler
        global_gemset = ( ENV["GEM_PATH"] || `rvm $(rvm current) do gem env path`.chop ).split(':').grep(/ruby.*@global/).first
        Dir["#{global_gemset}/gems/*"].each { |path| $LOAD_PATH << "#{path}/lib" } if global_gemset
      end
    end
    setup
  end

  def self.try_require(file)
    begin
      require file
      true
    rescue LoadError
      warn "=> Unable to load #{file}"
      false
    end
  end
end
