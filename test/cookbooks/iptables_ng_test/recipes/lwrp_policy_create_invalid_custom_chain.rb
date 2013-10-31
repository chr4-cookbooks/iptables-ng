iptables_ng_policy 'create-invalid-custom-chain' do
  table  'mangle'
  chain  'FOO!'
  policy 'DROP [0:0]'
  action :create
end
