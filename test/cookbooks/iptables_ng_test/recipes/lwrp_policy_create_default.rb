iptables_ng_policy 'policy-create-default' do
  chain  'FORWARD'
  policy 'DROP [0:0]'
  action :create
end
