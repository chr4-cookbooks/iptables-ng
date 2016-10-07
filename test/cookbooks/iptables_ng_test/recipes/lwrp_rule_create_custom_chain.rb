include_recipe 'iptables-ng::install'

# We need to create the custom chain first
iptables_ng_chain 'FOO' do
  table 'nat'
end

iptables_ng_rule 'custom-chain-output' do
  chain  'FOO'
  table  'nat'
  rule   '--protocol icmp --jump ACCEPT'
  action :create
end
