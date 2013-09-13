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

# This was implemented as a internal-only provider.
# Apparently, calling a LWRP from a LWRP doesnt' really work with
# subscribes / notifies. Therefore, using this workaround.
module Iptables
  module Manage
    def create_iptables_rules(ip_version)
      rules = {}

      # Retrieve all iptables rules for this ip_version,
      # as well as default policies
      Dir["/etc/iptables.d/*/*/*.rule_v#{ip_version}",
          '/etc/iptables.d/*/*/default'].each do |path|

        # /etc/iptables.d/#{table}/#{chain}/#{rule}.rule_v#{ip_version}
        table, chain, filename = path.split('/')[3..5]
        rule = ::File.basename(filename)

        # IPv6 doesn't support nat
        next if table == 'nat' and ip_version == 6

        # Create hashes unless they already exist, and add the rule
        rules[table] ||= {}
        rules[table][chain] ||= {}
        rules[table][chain][rule] = ::File.read(path)
      end

      iptables_restore = ''
      rules.each do |table, chains|
        iptables_restore << "*#{table}\n"

        # Get default policies and rules for this chain
        default_policies = chains.inject({}) {|new_chain, rule| new_chain[rule[0]] = rule[1].select{|k, v| k == 'default'}; new_chain }
        all_chain_rules  = chains.inject({}) {|new_chain, rule| new_chain[rule[0]] = rule[1].reject{|k, v| k == 'default'}; new_chain }

        # Apply default policies first
        default_policies.each do |chain, policy|
          iptables_restore << ":#{chain} #{policy['default'].chomp}\n"
        end

        # Apply rules for this chain, but sort before adding
        all_chain_rules.each do |chain, chain_rules|
          chain_rules.values.sort.each { |r| iptables_restore << "#{r.chomp}\n" }
        end

        iptables_restore << "COMMIT\n"
      end

      Chef::Resource::File.new(node['iptables-ng']["script_ipv#{ip_version}"], run_context).tap do |file|
        file.owner('root')
        file.group('root')
        file.mode(00600)
        file.content(iptables_restore)
        file.run_action(:create)
      end
    end


    def restart_service(ip_version)
      # restart iptables service if available
      if node['iptables-ng']["service_ipv#{ip_version}"]

        # Do not restart twice if the command is the same for IPv4 and IPv6
        return if node['iptables-ng']['service_ipv4'] == node['iptables-ng']['service_ipv6'] and ip_version == 6

        Chef::Resource::Service.new(node['iptables-ng']["service_ipv#{ip_version}"], run_context).tap do |service|
          service.supports(status: true, restart: true)
          service.run_action(:enable)
          service.run_action(:restart)
        end
      # if no service is available, apply the rules manually
      else
        Chef::Log.info 'applying rules manually, as no service is specified'
        Chef::Resource::Execute.new("iptables-restore for ipv#{ip_version}", run_context).tap do |execute|
          execute.command("iptables-restore < #{node['iptables-ng']['script_ipv4']}") if ip_version == 4
          execute.command("ip6tables-restore < #{node['iptables-ng']['script_ipv6']}") if ip_version == 6
          execute.run_action(:run)
        end
      end
    end
  end
end
