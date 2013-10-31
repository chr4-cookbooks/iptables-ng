iptables_ng_policy 'policy-create-custom' do
  chain  'FORWARD'
  table  'mangle'
  policy 'DROP [0:0]'
  action :create
end
