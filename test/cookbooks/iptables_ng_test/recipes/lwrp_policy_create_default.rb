iptables_ng_policy 'FORWARD' do
  policy 'DROP [0:0]'
  action :create
end
