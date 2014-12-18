require File.expand_path('../support/helpers', __FILE__)

describe 'iptables-ng::lwrp_chain_create' do
  include Helpers::TestHelpers

  it 'should delete default FORWARD policy' do
    file("#{node['iptables-ng']['scratch_dir']}/filter/FORWARD/default").wont_exist
  end
end
