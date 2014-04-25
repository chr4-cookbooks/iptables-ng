rules = Mash.new
bag = node['iptables-ng']['data_bag']

Array(node['iptables-ng']['data_bags']).each do |item|
  bag_item  = begin
    if node['iptables-ng']['secret']
      secret = Chef::EncryptedDataBagItem.load_secret(node['iptables-ng']['secret'])
      Chef::EncryptedDataBagItem.load(bag, item, secret)
    else
      data_bag_item(bag, item)
    end
  rescue => ex
    Chef::Log.info("Data bag #{bag} not found (#{ex}), so skipping")
    Hash.new
  end

  rules = Chef::Mixin::DeepMerge.merge(rules, bag_item['rules'])
end

node.set['iptables-ng']['rules'] = rules
include_recipe 'iptables-ng'
