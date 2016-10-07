#
# Cookbook Name:: iptables-ng
# Provider:: chain
#
# Copyright 2012, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require 'date'

action :create do
  new_resource.updated_by_last_action(true) if edit_chain(:create)
end

action :create_if_missing do
  new_resource.updated_by_last_action(true) if edit_chain(:create_if_missing)
end

action :delete do
  new_resource.updated_by_last_action(true) if edit_chain(:delete)
end

def edit_chain(exec_action)
  # only default chains can have a policy
  policy =
    if %w(INPUT OUTPUT FORWARD PREROUTING POSTROUTING).include?(new_resource.chain)
      new_resource.policy
    else
      '- [0:0]'
    end

  begin
    run_context.resource_collection.find(directory: "/etc/iptables.d/#{new_resource.table}/#{new_resource.chain}")
  rescue Chef::Exceptions::ResourceNotFound
    directory "/etc/iptables.d/#{new_resource.table}/#{new_resource.chain}" do
      owner  'root'
      group  node['root_group']
      mode   0o700
      not_if { exec_action == :delete }
    end
  end

  # Generating a random resource identifier, to workaround Chef cloning issues.
  rule_path = "/etc/iptables.d/#{new_resource.table}/#{new_resource.chain}/default"
  r = file "#{rule_path}-#{DateTime.now.to_time.to_i}-#{rand(100_000)}" do
    path     rule_path
    owner    'root'
    group    node['root_group']
    mode     0o600
    content  "#{policy}\n"
    notifies :create, 'ruby_block[create_rules]', :delayed
    notifies :create, 'ruby_block[restart_iptables]', :delayed
    action   exec_action
  end
  r.updated_by_last_action?
end
