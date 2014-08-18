require 'rubygems'
require '~/.irb/irb/ruby18.rb' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("1.9")
require '~/.irb/irb/gem_loader'
require '~/.irb/irb/pry_loader'
require '~/.irb/irb/custom' if File.exists?("#{Dir.home}/.irb/irb/custom.rb")

if defined? ::Pry
  IRB::TopLevel.new.pry
  exit
end
