#
# Cookbook Name:: iptables-ng
# Provider:: rule
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
  edit_rule(:create)
end

action :delete do
  edit_rule(:delete)
end


def edit_rule(exec_action)
  # Create rule for given ip_versions
  Array(new_resource.ip_version).each do |ip_version|
    rule_path = "/etc/iptables.d/#{new_resource.table}/#{new_resource.chain}/#{new_resource.name}.rule_v#{ip_version}"

    rule_file = ''
    Array(new_resource.rule).each { |r| rule_file << "--append #{new_resource.chain} #{r.chomp}\n" }

    r = file rule_path do
      mode     00700
      content  rule_file
      action   :nothing
    end
    r.run_action(exec_action)

    # create /etc/iptables/rules* if file is not existent or content is going to change
    if r.updated_by_last_action?
      iptables_ng_manage(ip_version).run_action(:apply)
      new_resource.updated_by_last_action(true)
    else
      iptables_ng_manage(ip_version).run_action(:apply) unless ::File.exists?(node['iptables-ng']["script_ipv#{ip_version}"])
    end
  end

  # TODO: link to .rule for rhel compatibility?
  # TODO: reload rules
end


