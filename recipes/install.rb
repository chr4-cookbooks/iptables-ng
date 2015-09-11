#
# Cookbook Name:: iptables-ng
# Recipe:: install
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

include_recipe 'iptables-ng::manage'

# Make sure iptables is installed
Array(node['iptables-ng']['packages']).each do |pkg|
  package pkg do
    notifies :run, 'execute[systemctl daemon-reload]', :immediately
  end
end

# Check to see if we're using systemd so we run systemctl daemon-reload to pick up new services
execute 'systemctl daemon-reload' do
  action :nothing
  only_if { IO.read('/proc/1/comm').chomp == 'systemd' }
end

# Make sure ufw is not installed on Ubuntu/Debian, as it might interfere
package 'ufw' do
  action :remove
  only_if { node['platform_family'] == 'debian' }
end

# Create directories
directory '/etc/iptables.d' do
  mode 00700
end

node['iptables-ng']['rules'].each do |table, chains|
  # Skip deactivated tables
  next unless node['iptables-ng']['enabled_tables'].include?(table)

  directory "/etc/iptables.d/#{table}" do
    mode 00700
  end

  # Create default policies unless they exist
  chains.each do |chain, policy|
    iptables_ng_chain "default-policy-#{table}-#{chain}" do
      chain  chain
      table  table
      policy policy['default']
      action :create_if_missing
    end
  end
end
