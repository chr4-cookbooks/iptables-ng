#
# Cookbook Name:: iptables-ng
# Attributes:: default
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

# Which IP versions to manage rules for
default['iptables-ng']['enabled_ip_versions'] = [4, 6]

# Which tables to manage:
# When using containered setup (OpenVZ, Docker, LXC) it might might be
# necessary to remove the "nat" and "raw" tables.
default['iptables-ng']['enabled_tables'] = %w(nat filter mangle raw)

# Packages to install
default['iptables-ng']['packages'] = case node['platform_family']
when 'debian'
  %w(iptables iptables-persistent)
when 'rhel'
  if node['platform_version'].to_f >= 7.0
    %w(iptables iptables-services)
  else
    %w(iptables iptables-ipv6)
  end
else
  %w(iptables)
end

#Where to store rules as they are being built
default['iptables-ng']['scratch_dir'] = '/etc/iptables.d'

# Where the rules are stored and how they are executed
case node['platform']
when 'debian'
  # Debian squeeze (and before) only support an outdated version
  # of iptables-persistent, which is not capable of ipv6.
  # Furthermore, restarting the service doesn't properly reload the rules
  if node['platform_version'].to_f < 7.0
    # default['iptables-ng']['service_ipv4'] = 'iptables-persistent'
    default['iptables-ng']['script_ipv4'] = '/etc/iptables/rules'
    default['iptables-ng']['script_ipv6'] = '/etc/iptables/rules.v6'
  else
    default['iptables-ng']['service_ipv4'] = 'iptables-persistent'
    default['iptables-ng']['service_ipv6'] = 'iptables-persistent'
    default['iptables-ng']['script_ipv4'] = '/etc/iptables/rules.v4'
    default['iptables-ng']['script_ipv6'] = '/etc/iptables/rules.v6'
  end

when 'ubuntu'
  if node['platform_version'].to_f >= 14.10
    default['iptables-ng']['service_ipv4'] = 'netfilter-persistent'
    default['iptables-ng']['service_ipv6'] = 'netfilter-persistent'
  else
    default['iptables-ng']['service_ipv4'] = 'iptables-persistent'
    default['iptables-ng']['service_ipv6'] = 'iptables-persistent'
  end
  default['iptables-ng']['script_ipv4'] = '/etc/iptables/rules.v4'
  default['iptables-ng']['script_ipv6'] = '/etc/iptables/rules.v6'

when 'redhat', 'centos', 'scientific', 'amazon', 'fedora'
  default['iptables-ng']['service_ipv4'] = 'iptables'
  default['iptables-ng']['service_ipv6'] = 'ip6tables'
  default['iptables-ng']['script_ipv4'] = '/etc/sysconfig/iptables'
  default['iptables-ng']['script_ipv6'] = '/etc/sysconfig/ip6tables'

when 'gentoo'
  default['iptables-ng']['service_ipv4'] = 'iptables'
  default['iptables-ng']['service_ipv6'] = 'ip6tables'
  default['iptables-ng']['script_ipv4'] = '/var/lib/iptables/rules-save'
  default['iptables-ng']['script_ipv6'] = '/var/lib/ip6tables/rules-save'

when 'arch'
  default['iptables-ng']['service_ipv4'] = 'iptables'
  default['iptables-ng']['service_ipv6'] = 'ip6tables'
  default['iptables-ng']['script_ipv4'] = '/etc/iptables/iptables.rules'
  default['iptables-ng']['script_ipv6'] = '/etc/iptables/ip6tables.rules'

else
  default['iptables-ng']['script_ipv4'] = '/etc/iptables-rules.ipt'
  default['iptables-ng']['script_ipv6'] = '/etc/ip6tables-rules.ipt'
end
