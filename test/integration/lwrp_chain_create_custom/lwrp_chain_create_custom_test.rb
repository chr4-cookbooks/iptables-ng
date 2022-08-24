# Should set mangle FORWARD policy to DROP
describe file('/etc/iptables.d/mangle/FORWARD/default') do
  it { should exist }
  its('content') { should match('DROP \[0\:0\]') }
end

service_ipv4 = case os.family
               when 'debian'
                 'netfilter-persistent'
               else
                 'iptables'
               end

service_ipv6 = case os.family
               when 'debian'
                 'netfilter-persistent'
               else
                 'ip6tables'
               end

# Should enable iptables serices
describe service(service_ipv4) do
  it { should be_enabled }
end

describe service(service_ipv6) do
  it { should be_enabled }
end

# Should apply the specified iptables rules
describe command('iptables -t mangle -L -n') do
  its('stdout') { should match('Chain FORWARD \(policy DROP\)') }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -t mangle -L -n') do
  its('stdout') { should match('Chain FORWARD \(policy DROP\)') }
  its('exit_status') { should eq 0 }
end
