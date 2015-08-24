require 'chefspec'
require 'chefspec/berkshelf'

# Require all our libraries
Dir.glob('libraries/*.rb').sort.each { |f| require File.expand_path(f) }

ChefSpec::Coverage.start!
