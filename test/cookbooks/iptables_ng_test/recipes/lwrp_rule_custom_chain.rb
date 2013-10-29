iptables_ng_rule 'custom-chain' do
  chain  'fail2ban'
  table  'filter'
  rule   '--source 127.0.0.3 --jump DROP'
  action :create
end
