module IRB
  module GemLoader
    def self.irb_gemsetpath
      # For rbenv, we load the gems from our special directory
      path = `rbenv which ruby 2> /dev/null`.chop.split('/')[0..-3].join('/') rescue nil
      return path + "/lib/ruby/gems/irb-config" if path.to_s.size > 0

      # On RVM, We make everything in the global gemset available, bypassing Bundler
      (ENV["GEM_PATH"] || `rvm $(rvm current) do gem env path`.chop).split(':').grep(/ruby.*@global/).first rescue nil
    end

    def self.setup
      irb_gemset = irb_gemsetpath
      Dir["#{irb_gemset}/gems/*"].each { |path| $LOAD_PATH << "#{path}/lib" } if irb_gemset
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
