require 'rubygems'
require '~/.irb/irb/gem_loader'
require '~/.irb/irb/pry_loader'

if defined? ::Pry
  IRB::TopLevel.new.pry
  exit
end
