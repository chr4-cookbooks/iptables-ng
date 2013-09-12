iptables_ng_rule 'output-rule' do
  chain  'OUTPUT'
  filter 'mangle'
  rule   '--protocol icmp --jump ACCEPT'
  action :create
end
