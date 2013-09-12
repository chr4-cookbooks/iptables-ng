iptables_ng_rule 'ssh' do
  rule   '--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT'
  action :create
end
