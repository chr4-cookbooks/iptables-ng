iptables_ng_policy 'create-if-missing' do
  chain  'FOWARD'
  policy 'DROP [0:0]'
  action :create_if_missing
end
