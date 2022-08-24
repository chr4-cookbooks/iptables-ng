# Should set all default policies to ACCEPT'

# filter
describe file('/etc/iptables.d/filter/INPUT/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end
describe file('/etc/iptables.d/filter/OUTPUT/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end
describe file('/etc/iptables.d/filter/FORWARD/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end

# nat
describe file('/etc/iptables.d/nat/OUTPUT/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end
describe file('/etc/iptables.d/nat/PREROUTING/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end
describe file('/etc/iptables.d/nat/POSTROUTING/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end

# mangle
describe file('/etc/iptables.d/mangle/INPUT/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end
describe file('/etc/iptables.d/mangle/OUTPUT/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end
describe file('/etc/iptables.d/mangle/FORWARD/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end
describe file('/etc/iptables.d/mangle/PREROUTING/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end
describe file('/etc/iptables.d/mangle/POSTROUTING/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end

# raw
describe file('/etc/iptables.d/raw/OUTPUT/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end
describe file('/etc/iptables.d/raw/PREROUTING/default') do
  it { should exist }
  its('content') { should match('ACCEPT \[0\:0\]') }
end

# Should not apply other iptables rules
describe command('iptables -L -n |wc -l') do
  its('stdout.strip') { should eq('8') }
  its('exit_status') { should eq 0 }
end

describe command('iptables -L -n -t nat |wc -l') do
  its('stdout.strip') { should eq('11') }
  its('exit_status') { should eq 0 }
end

describe command('iptables -L -n -t mangle |wc -l') do
  its('stdout.strip') { should eq('14') }
  its('exit_status') { should eq 0 }
end

describe command('iptables -L -n -t raw |wc -l') do
  its('stdout.strip') { should eq('5') }
  its('exit_status') { should eq 0 }
end

# Should not apply other ip6tables rules
describe command('ip6tables -L -n |wc -l') do
  its('stdout.strip') { should eq('8') }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -L -n -t mangle |wc -l') do
  its('stdout.strip') { should eq('14') }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -L -n -t raw |wc -l') do
  its('stdout.strip') { should eq('5') }
  its('exit_status') { should eq 0 }
end

# Should apply default policies in filter table
describe command('iptables -L -n') do
  its('stdout') { should match('Chain INPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain OUTPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain FORWARD \(policy ACCEPT\)') }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -L -n') do
  its('stdout') { should match('Chain INPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain OUTPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain FORWARD \(policy ACCEPT\)') }
  its('exit_status') { should eq 0 }
end

# Should apply default policies in nat table
describe command('iptables -L -n -t nat') do
  its('stdout') { should match('Chain INPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain OUTPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain PREROUTING \(policy ACCEPT\)') }
  its('stdout') { should match('Chain POSTROUTING \(policy ACCEPT\)') }
  its('exit_status') { should eq 0 }
end

# Should apply default policies in mangle table
describe command('iptables -L -n -t mangle') do
  its('stdout') { should match('Chain INPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain OUTPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain FORWARD \(policy ACCEPT\)') }
  its('stdout') { should match('Chain PREROUTING \(policy ACCEPT\)') }
  its('stdout') { should match('Chain POSTROUTING \(policy ACCEPT\)') }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -L -n -t mangle') do
  its('stdout') { should match('Chain INPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain OUTPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain FORWARD \(policy ACCEPT\)') }
  its('stdout') { should match('Chain PREROUTING \(policy ACCEPT\)') }
  its('stdout') { should match('Chain POSTROUTING \(policy ACCEPT\)') }
  its('exit_status') { should eq 0 }
end

# Should apply default policies in raw table
describe command('iptables -L -n -t raw') do
  its('stdout') { should match('Chain OUTPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain PREROUTING \(policy ACCEPT\)') }
  its('exit_status') { should eq 0 }
end

describe command('ip6tables -L -n -t raw') do
  its('stdout') { should match('Chain OUTPUT \(policy ACCEPT\)') }
  its('stdout') { should match('Chain PREROUTING \(policy ACCEPT\)') }
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
