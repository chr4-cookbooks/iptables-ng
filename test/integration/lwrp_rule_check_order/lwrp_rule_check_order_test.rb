script_ipv4 = case os.family
              when 'debian'
                '/etc/iptables/rules.v4'
              when 'redhat'
                '/etc/sysconfig/iptables'
              else
                '/etc/iptables-rules.ipt'
              end

# Should concatinate iptables rules in specified order
describe file(script_ipv4) do
  it { should exist }
  its('content') { should match(/--sport 110.*--dport 20.*--dport 50.*--dport 51.*--dport 998.*--dport 99/m) }
end
