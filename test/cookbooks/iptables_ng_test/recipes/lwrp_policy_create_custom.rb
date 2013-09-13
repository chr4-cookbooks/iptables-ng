iptables_ng_policy 'FORWARD' do
  table  'mangle'
  policy 'DROP [0:0]'
  action :create
end
