module IRB
  module GemLoader
    def self.setup
      # For rbenv, we load the gems from our special directory
      irb_gemset = `rbenv which ruby`.chop.split('/')[0..-3].join('/') + "/lib/ruby/gems/irb-config" rescue nil
      # On RVM, We make everything in the global gemset available, bypassing Bundler
      irb_gemset ||= ( ENV["GEM_PATH"] || `rvm $(rvm current) do gem env path`.chop ).split(':').grep(/ruby.*@global/).first rescue nil
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
