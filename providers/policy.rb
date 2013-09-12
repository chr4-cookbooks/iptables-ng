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

action :set do
  edit_policy(:set)
end

action :apply do
  edit_policy(:apply)
end

def edit_policy(exec_action)
  rule_path = "/etc/iptables.d/#{new_resource.table}/#{new_resource.chain}/default"

  r = file rule_path do
    owner    'root'
    group    'root'
    mode     00600
    content  "#{new_resource.policy}\n"
    notifies :create, 'ruby_block[create_rules]', :delayed
    notifies :create, 'ruby_block[restart_iptables]', :delayed
    action   :create
  end

  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end
