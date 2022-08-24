# Should set custom iptables rule
describe file('/etc/iptables.d/nat/OUTPUT/custom-output.rule_v4') do
  it { should exist }
  its('content') { should match('--protocol icmp --jump ACCEPT') }
end

# Should set custom ip6tables rule
describe file('/etc/iptables.d/nat/OUTPUT/custom-output.rule_v6') do
  it { should exist }
  its('content') { should match('--protocol icmp --jump ACCEPT') }
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
describe command('iptables -t nat -L -n') do
  its('stdout') { should match(/ACCEPT\s+icmp/) }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -t nat -L -n') do
  its('stdout') { should match(/ACCEPT\s+icmp/) }
  its('exit_status') { should eq 0 }
end
