# Should not set HTTP rule
describe file('/etc/iptables.d/filter/INPUT/http.rule_v4') do
  it { should_not exist }
end

# Should not set HTTP ip6tables rule
describe file('/etc/iptables.d/filter/INPUT/http.rule_v6') do
  it { should_not exist }
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
  its('stdout') { should_not match('tcp dpt:80 state NEW') }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -L -n') do
  its('stdout') { should_not match('tcp dpt:80 state NEW') }
  its('exit_status') { should eq 0 }
end
