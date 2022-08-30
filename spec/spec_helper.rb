require 'chefspec'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '20.04'
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
