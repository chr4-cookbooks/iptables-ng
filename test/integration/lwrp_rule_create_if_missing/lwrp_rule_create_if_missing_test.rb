# Should set SSH iptables rule
describe file('/etc/iptables.d/filter/INPUT/ssh.rule_v4') do
  it { should exist }
  its('content') { should match('--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT') }
  its('content') { should_not match('--protocol tcp --dport 80 --match state --state NEW --jump ACCEPT') }
end

# Should set SSH ip6tables rule
describe file('/etc/iptables.d/filter/INPUT/ssh.rule_v6') do
  it { should exist }
  its('content') { should match('--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT') }
  its('content') { should_not match('--protocol tcp --dport 80 --match state --state NEW --jump ACCEPT') }
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
describe command('iptables -L -n') do
  its('stdout') { should match('tcp dpt:22 state NEW') }
  its('stdout') { should_not match('tcp dpt:80 state NEW') }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -L -n') do
  its('stdout') { should match('tcp dpt:22 state NEW') }
  its('stdout') { should_not match('tcp dpt:80 state NEW') }
  its('exit_status') { should eq 0 }
end
