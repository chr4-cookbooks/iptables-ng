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

# make sure iptables is installed
Array(node['iptables-ng']['packages']).each { |pkg| package pkg }

# make sure ufw is not installed on ubuntu/debian, as it might interfere
package 'ufw' do
  action  :purge
  only_if { node['platform_family'] == 'debian' }
end


# create directories
directory '/etc/iptables.d' do
  mode   00700
end

node['iptables-ng']['rules'].each do |table, chains|
  directory "/etc/iptables.d/#{table}" do
    mode 00700
  end

  chains.keys.each do |chain|
    directory "/etc/iptables.d/#{table}/#{chain}" do
      mode 00700
    end
  end

  # Apply default policies
  chains.each do |chain, policy|
    iptables_ng_policy chain do
      table  table
      policy policy['default']
    end
  end
end


# enable iptables service on boot time (if available)
service node['iptables-ng']['service_ipv4'] do
  supports status: true, restart: true
  action   :enable
  only_if  { node['iptables-ng']['service_ipv4'] }
end

service node['iptables-ng']['service_ipv6'] do
  supports status: true, restart: true
  action   :enable
  only_if  { node['iptables-ng']['service_ipv6'] }
end
