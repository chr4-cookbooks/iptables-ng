#
# Cookbook Name:: iptables-ng
# Provider:: policy
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

action :create do
  edit_policy(:create)
end

action :create_if_missing do
  edit_policy(:create_if_missing)
end

action :delete do
  edit_policy(:delete)
end

def edit_policy(exec_action)

  rule_dir = "/etc/iptables.d/#{new_resource.table}/#{new_resource.chain}"

  dir_action = exec_action
  if :create_if_missing == exec_action
      dir_action = :create
  end
  d = directory rule_dir do
    owner 'root'
    group 'root'
    mode 00700
    action dir_action
  end

  rule_path = "/etc/iptables.d/#{new_resource.table}/#{new_resource.chain}/default"

  r = file rule_path do
    owner    'root'
    group    'root'
    mode     00600
    content  "#{new_resource.policy}\n"
    notifies :create, 'ruby_block[create_rules]', :delayed
    notifies :create, 'ruby_block[restart_iptables]', :delayed
    action   exec_action
  end

  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end
