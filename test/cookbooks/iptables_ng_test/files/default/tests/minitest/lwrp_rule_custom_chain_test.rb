require File.expand_path('../support/helpers', __FILE__)

describe 'iptables-ng::lwrp_custom_chain' do
  include Helpers::TestHelpers

  it 'should set custom iptables rule' do
    file('/etc/iptables.d/filter/fail2ban/custom-chain.rule_v4').must_include('--protocol icmp --jump ACCEPT')
  end

  it 'should not set custom ip6tables rule for nat chain' do
    file('/etc/iptables.d/filter/fail2ban/custom-chain.rule_v6').wont_exist
  end

  it 'should enable iptables serices' do
    service(node['iptables-ng']['service_ipv4']).must_be_enabled if node['iptables-ng']['service_ipv4']
    service(node['iptables-ng']['service_ipv6']).must_be_enabled if node['iptables-ng']['service_ipv6']
  end

  it 'should apply the specified iptables rules' do
    ipv4 = shell_out('iptables -t filter -L fail2ban -n')
    ipv4.stdout.must_match(/127\.0\.0\.3.*REJECT/)
  end
end
