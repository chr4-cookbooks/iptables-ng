#
# Cookbook Name:: iptables-ng
# Recipe:: manage
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
ip = node['iptables-ng']
tables = ip['enabled_tables'].dup

Array(ip['enabled_ip_versions']).sort.each do |version|
  if version == 6
    tables.delete('nat') unless ip['ip6tables_nat_support']
  end

  file ip["script_ipv#{version}"] do
    content Iptables::Manage.create_config(version, tables, run_context)
    notifies :run, 'ruby_block[restart_iptables]', :delayed
  end
end

ruby_block 'restart_iptables' do
  block do
    if node['iptables-ng']['managed_service']
      Array(node['iptables-ng']['enabled_ip_versions']).sort.each do |version|
        Iptables::Manage.restart_service(version, ip, run_context)
      end
    end
  end
  action :nothing
end
