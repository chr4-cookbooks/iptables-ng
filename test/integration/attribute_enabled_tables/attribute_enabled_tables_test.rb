# Should not create default mangle FORWARD policy
describe file('/etc/iptables.d/mangle/FORWARD/default4') do
  it { should_not exist }
end

# Should not create default nat FORWARD policy
describe file('/etc/iptables.d/nat/FORWARD/default') do
  it { should_not exist }
end

# Should not create default raw FORARD policy
describe file('/etc/iptables.d/raw/default') do
  it { should_not exist }
end

# Should not create iptables OUTPUT test_rule
describe file('/etc/iptables.d/filter/OUTPUT/testrule-filter-OUTPUT-attribute-rule.rule_v4') do
  it { should_not exist }
end

# Should not create ip6tables OUTPUT test_rule
describe file('/etc/iptables.d/filter/OUTPUT/testrule-filter-OUTPUT-attribute-rule.rule_v6') do
  it { should_not exist }
end

# Should create SSH iptables rule
describe file('/etc/iptables.d/filter/INPUT/ssh-filter-INPUT-attribute-rule.rule_v4') do
  it { should exist }
  its('content') { should match('--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT') }
end

# Should create SSH ip6tables rule
describe file('/etc/iptables.d/filter/INPUT/ssh-filter-INPUT-attribute-rule.rule_v6') do
  it { should exist }
  its('content') { should match('--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT') }
end

# Should apply SSH iptables rule
describe command('iptables -L -n') do
  its('stdout') { should match('tcp dpt:22 state NEW') }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -L -n') do
  its('stdout') { should match('tcp dpt:22 state NEW') }
  its('exit_status') { should eq 0 }
end

# Should create ipv4_only iptables rule
describe file('/etc/iptables.d/filter/INPUT/ipv4_only-filter-INPUT-attribute-rule.rule_v4') do
  it { should exist }
  its('content') { should match('--protocol tcp --source 1.2.3.4 --dport 123 --jump ACCEPT') }
end

# Should not create ipv4_only ip6tables rule
describe file('/etc/iptables.d/filter/INPUT/ipv4_only-filter-INPUT-attribute-rule.rule_v6') do
  it { should_not exist }
end

# Should apply ipv4_only iptables rule
describe command('iptables -L -n') do
  its('stdout') { should match('tcp dpt:123') }
  its('exit_status') { should eq 0 }
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
