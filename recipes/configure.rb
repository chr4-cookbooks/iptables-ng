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
  # Skip deactivated tables
  next unless node['iptables-ng']['enabled_tables'].include?(table_name)

  chains.each do |chain_name, p|
    # policy is read only, duplicate it
    pol = p.dup

    # Apply chain policy
    iptables_ng_chain "default-policy-#{table_name}-#{chain_name}" do
      chain  chain_name
      table  table_name
      policy pol.delete('default')
    end

    # Gather rules from filesystem to delete unused ones later
    unused = Dir["/etc/iptables.d/#{table_name}/#{chain_name}/*-#{table_name}-#{chain_name}-attribute-rule.*"]

    # Apply rules
    pol.each do |name, r|
      res = iptables_ng_rule "#{name}-#{table_name}-#{chain_name}-attribute-rule" do
        chain      chain_name
        table      table_name
        rule       r['rule']
        ip_version r['ip_version'] if r['ip_version']
        action     r['action'].to_sym if r['action']
      end

      # Remove from unused rules
      unused -= res.paths
    end

    # Delete unused rules now
    unused.each do |path|
      file path do
        notifies :create, 'ruby_block[create_rules]', :delayed
        notifies :create, 'ruby_block[restart_iptables]', :delayed
        action :delete
      end
    end
  end
end
