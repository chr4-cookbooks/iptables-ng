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

action :create_if_missing do
  edit_rule(:create_if_missing)
end

action :delete do
  edit_rule(:delete)
end

def edit_rule(exec_action)
  # Create rule for given ip_versions
  Array(new_resource.ip_version).each do |ip_version|
    # Skip nat table if ip6tables doesn't support it
    next if new_resource.table == 'nat' &&
            node['iptables-ng']['ip6tables_nat_support'] == false &&
            ip_version == 6

    rule_file = ''
    Array(new_resource.rule).each { |r| rule_file << "--append #{new_resource.chain} #{r.chomp}\n" }

    r = file new_resource.path_for_ip_version(ip_version) do
      owner    'root'
      group    node['root_group']
      mode     0o600
      content  rule_file
      notifies :create, 'ruby_block[create_rules]', :delayed
      notifies :create, 'ruby_block[restart_iptables]', :delayed
      action   exec_action
    end

    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end

  # TODO: link to .rule for rhel compatibility?
end
