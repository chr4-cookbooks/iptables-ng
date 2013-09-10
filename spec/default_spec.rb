require 'chefspec'

describe 'iptables-ng::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'iptables-ng::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
