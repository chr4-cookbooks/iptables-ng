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

# ruby_bock doesn't support chef resources, so defining them here
iptables_scripts = {
  4 => file(node['iptables-ng']['script_ipv4']) { action :nothing },
  6 => file(node['iptables-ng']['script_ipv6']) { action :nothing },
}

ruby_block 'apply_rules' do
  block do
   [4, 6].each do |ip_version|
      rules = {}

      # Retrieve all iptables rules for this ip_version,
      # as well as default policies
      Dir["/etc/iptables.d/*/*/*.rule_v#{ip_version}",
          '/etc/iptables.d/*/*/default'].each do |path|

        # /etc/iptables.d/#{table}/#{chain}/#{rule}.rule_v#{ip_version}
        table, chain, filename = path.split('/')[3..5]
        rule = ::File.basename(filename)

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

      iptables_scripts[ip_version].owner('root')
      iptables_scripts[ip_version].group('root')
      iptables_scripts[ip_version].mode(00600)
      iptables_scripts[ip_version].content(iptables_restore)
      iptables_scripts[ip_version].run_action(:create)
    end
  end

  # create iptables restore scripts unless they exist, else wait for something to change
  unless ::File.exists?(node['iptables-ng']['script_ipv4']) and ::File.exists?(node['iptables-ng']['script_ipv6'])
    action :create
  else
    action :nothing
  end
end
