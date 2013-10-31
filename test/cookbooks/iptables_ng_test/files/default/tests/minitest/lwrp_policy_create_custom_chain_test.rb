require File.expand_path('../support/helpers', __FILE__)

describe 'iptables-ng::lwrp_policy_create_custom_chain' do
  include Helpers::TestHelpers

  it 'should create the custom chain directory' do
      directory('/etc/iptables.d/mangle/FOO').must_exist
  end

  it 'should set default mangle FOO policy to DROP' do
    file('/etc/iptables.d/mangle/FOO/default').must_include('DROP [0:0]')
  end

  it 'should enable iptables serices' do
    service(node['iptables-ng']['service_ipv4']).must_be_enabled if node['iptables-ng']['service_ipv4']
    service(node['iptables-ng']['service_ipv6']).must_be_enabled if node['iptables-ng']['service_ipv6']
  end

  it 'should apply the specified iptables rules' do
    ipv4 = shell_out('iptables -t mangle -L -n')
    ipv4.stdout.must_include('Chain FOO (policy DROP)')

    ipv6 = shell_out('ip6tables -t mangle -L -n')
    ipv6.stdout.must_include('Chain FOO (policy DROP)')
  end
end
