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

# This recipe only creates ruby_blocks that are called later by the LWRPs
# Do not use it by its own

ruby_block 'create_rules' do
  block do
    class Chef::Resource::RubyBlock
      include Iptables::Manage
    end

    Array(node['iptables-ng']['enabled_ip_versions']).each do |ip_version|
      create_iptables_rules(ip_version)
    end
  end

  action :nothing
end

modern_and_paranoid = node['iptables-ng']['safe_reload'] && Chef::VERSION.to_f >= 12.5

if modern_and_paranoid
  Chef.event_handler do
    on :converge_complete do
      Array(node['iptables-ng']['enabled_ip_versions']).each do |ip_version|
        Iptables::Manage.conditionally_restart_service(ip_version, run_context)
      end if node['iptables-ng']['managed_service']
    end
  end
end

ruby_block 'restart_iptables' do
  block do
    Array(node['iptables-ng']['enabled_ip_versions']).each do |ip_version|
      Iptables::Manage.conditionally_restart_service(ip_version, run_context)
    end if node['iptables-ng']['managed_service']
  end
  not_if { modern_and_paranoid }
  action :nothing
end
