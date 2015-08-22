#
# Cookbook Name:: iptables-ng
# Recipe:: configure
#
# Copyright 2013, Chris Aumann
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

# Apply rules from node attributes
node['iptables-ng']['rules'].each do |table_name, chains|
  next unless node['iptables-ng']['enabled_tables'].include?(table_name)

  chains.each do |chain_name, policy|
    # policy is read only, duplicate it
    p = policy.dup

    # Apply chain policy
    iptables_ng_chain "attribute-policy-#{table_name}-#{chain_name}" do
      chain chain_name
      table table_name
      policy p.delete('default')
    end

    # Apply rules
    p.each do |name, r|
      iptables_ng_rule "attribute-rule-#{name}-#{table_name}-#{chain_name}" do
        chain chain_name
        table table_name
        rule r['rule']
        ip_version r['ip_version'] if r['ip_version']
        action r['action'].to_sym if r['action']
      end
    end
  end
end
