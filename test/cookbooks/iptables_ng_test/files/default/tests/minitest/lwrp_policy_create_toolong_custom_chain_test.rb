require File.expand_path('../support/helpers', __FILE__)

describe 'iptables-ng::lwrp_policy_create_toolong_custom_chain' do
  include Helpers::TestHelpers

  it 'should not create a rule when the chain name is too long' do
    file('/etc/iptables.d/mangle/THIS_IS_WAY_TOO_LONG_FOR_AN_IPTABLES_CHAIN_NAME/default').must_not_exist
  end

  it 'should enable iptables serices' do
    service(node['iptables-ng']['service_ipv4']).must_be_enabled if node['iptables-ng']['service_ipv4']
    service(node['iptables-ng']['service_ipv6']).must_be_enabled if node['iptables-ng']['service_ipv6']
  end

  it 'should not apply the specified iptables rules' do
    ipv4 = shell_out('iptables -t mangle -L -n')
    ipv4.stdout.must_not_include('Chain THIS_IS_WAY_TOO_LONG_FOR_AN_IPTABLES_CHAIN_NAME (policy DROP)')

    ipv6 = shell_out('ip6tables -t mangle -L -n')
    ipv6.stdout.must_not_include('Chain THIS_IS_WAY_TOO_LONG_FOR_AN_IPTABLES_CHAIN_NAME (policy DROP)')
  end
end
