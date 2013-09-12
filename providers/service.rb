#
# Cookbook Name:: iptables-ng
# Provider:: service
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

action :restart do
  [4, 6].each do |ip_version|
    # restart iptables service if available
    if node['iptables-ng']["service_ipv#{ip_version}"]
      r = service node['iptables-ng']["service_ipv#{ip_version}"] do
        supports status: true, restart: true
        action [ :enable, :restart ]

        # Do not restart twice if the command is the same for IPv4 and IPv6
        not_if { node['iptables-ng']['service_ipv4'] == node['iptables-ng']['service_ipv6'] and ip_version == 6 }
      end

    # if no service is available, apply the rules manually
    else
      Chef::Log.info 'applying rules manually, as no service is specified'
      r = execute "iptables-restore for ipv#{ip_version}" do
        command  "iptables-restore < #{node['iptables-ng']['script_ipv4']}" if ip_version == 4
        command  "ip6tables-restore < #{node['iptables-ng']['script_ipv6']}" if ip_version == 6
        action   :run
      end
    end

    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end
end
