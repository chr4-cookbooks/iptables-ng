require File.expand_path('../support/helpers', __FILE__)

describe 'iptables-ng::lwrp_policy_create_invalid_custom_chain' do
  include Helpers::TestHelpers

  it 'should not create a policy when the chain name is invalid' do
    file('/etc/iptables.d/mangle/FOO!/default').must_not_exist
  end

  it 'should enable iptables serices' do
    service(node['iptables-ng']['service_ipv4']).must_be_enabled if node['iptables-ng']['service_ipv4']
    service(node['iptables-ng']['service_ipv6']).must_be_enabled if node['iptables-ng']['service_ipv6']
  end

  it 'should not apply the specified iptables rules' do
    ipv4 = shell_out('iptables -t mangle -L -n')
    ipv4.stdout.must_not_include('Chain FOO! (policy DROP)')

    ipv6 = shell_out('ip6tables -t mangle -L -n')
    ipv6.stdout.must_not_include('Chain FOO! (policy DROP)')
  end
end
