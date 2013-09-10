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
  rule_path = "/etc/iptables.d/#{new_resource.table}/#{new_resource.chain}/default"

  r = file(rule_path) do
    mode    00700
    content "#{new_resource.policy}\n"
    action  :create
  end

  m = iptables_ng_manage([ 4, 6 ])
  m.subscribes(:apply, "file[#{rule_path}", :delayed)

  # create /etc/iptables/rules* if file is not existent or content is going to change
  if r.updated_by_last_action?
    new_resource.updated_by_last_action(true)
  else
    m.run_action(:apply) unless ::File.exists?(node['iptables-ng']['script_ipv4'])
  end
end
