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

default['iptables-ng'].tap do |ip|
  # Which IP versions to manage rules for
  ip['enabled_ip_versions'] = [4, 6]

  # Which tables to manage:
  # When using containered setup (OpenVZ, Docker, LXC) it might might be
  # necessary to remove the "nat" and "raw" tables.
  ip['enabled_tables'] = IptablesNG::Helpers::TABLES

  # Configure whether the service should be managed by Chef
  # /!\ Be careful when using this feature as it might leave your server in an inconsistent state.
  # See https://github.com/chr4-cookbooks/iptables-ng/pull/42 for more details.
  ip['managed_service'] = true

  # Enable nat support for ipv6
  # Older distributions do not support ipv6 nat, but recent Ubuntu does
  ip['ip6tables_nat_support'] = value_for_platform(
    'ubuntu' => { '14.04' => true, '14.10' => true, 'default' => false },
    'default' => false,
  )

  # Packages to install
  ip['packages'] =
    case node['platform_family']
    when 'debian'
      %w( iptables iptables-persistent )
    when 'rhel'
      if node['platform'] == 'amazon'
        %w( iptables )
      elsif node['platform_version'].to_f >= 7.0
        %w( iptables iptables-services )
      else
        %w( iptables iptables-ipv6 )
      end
    else
      %w( iptables )
    end

  # Services to manage, if any
  ip['service_ipv4'], ip['service_ipv6'] =
    case node['platform']
    when 'debian'
      # Debian squeeze (and before) only support an outdated version
      # of iptables-persistent, which is not capable of ipv6.
      # Furthermore, restarting the service doesn't properly reload the rules
      if node['platform_version'].to_f >= 8.0
        %w( netfilter-persistent netfilter-persistent )
      elsif node['platform_version'].to_f >= 7.0
        %w( iptables-persistent iptables-persistent )
      else
        %w()
      end
    when 'ubuntu'
      if node['platform_version'].to_f >= 14.10
        %w( netfilter-persistent netfilter-persistent )
      else
        %w( iptables-persistent iptables-persistent )
      end
    when 'redhat', 'centos', 'scientific', 'amazon', 'fedora', 'gentoo', 'arch'
      %w( iptables ip6tables )
    else
      %w()
    end

  # Where the rules are stored
  ip['script_ipv4'], ip['script_ipv6'] =
    case node['platform']
    when 'debian'
      if node['platform_version'].to_f < 7.0
        %w( /etc/iptables/rules /etc/iptables/rules.v6 )
      else
        %w( /etc/iptables/rules.v4 /etc/iptables/rules.v6 )
      end
    when 'redhat', 'centos', 'scientific', 'amazon', 'fedora'
      %w( /etc/sysconfig/iptables /etc/sysconfig/ip6tables )
    when 'gentoo'
      %w( /var/lib/iptables/rules-save /var/lib/ip6tables/rules-save )
    when 'arch'
      %w( /etc/iptables/iptables.rules /etc/iptables/ip6tables.rules )
    else
      %w( /etc/iptables-rules.ipt /etc/ip6tables-rules.ipt )
    end
end
