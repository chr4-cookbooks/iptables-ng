#
# Cookbook Name:: iptables-ng
# Provider:: manage
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

action :apply do
  rules = {}

  # Retrieve all iptables rules for this ip_version,
  # as well as default policies
  Dir["/etc/iptables.d/*/*/*.rule_v#{new_resource.ip_version}",
      '/etc/iptables.d/*/*/default'].each do |path|

    # /etc/iptables.d/#{table}/#{chain}/#{rule}.rule_v#{ip_version}
    table, chain, filename = path.split('/')[3..5]
    rule = ::File.basename(filename)

    # Create hashes unless they already exist, and add the rule
    rules[table] ||= {}
    rules[table][chain] ||= {}
    rules[table][chain][rule] = ::File.read(path)
  end

  rules_file = ''
  rules.each do |table, chains|
    rules_file << "*#{table}\n"

    # Get default policies and rules for this chain
    default_policies = chains.inject({}) {|new_chain, rule| new_chain[rule[0]] = rule[1].select{|k, v| k == 'default'}; new_chain }
    all_chain_rules = chains.inject({}) {|new_chain, rule| new_chain[rule[0]] = rule[1].reject{|k, v| k == 'default'}; new_chain }

    # Apply default policies first
    default_policies.each do |chain, policy|
      rules_file << ":#{chain} #{policy['default'].chomp}\n"
    end

    # Apply rules for this chain, but sort before adding
    all_chain_rules.each do |chain, chain_rules|
      chain_rules.values.sort.each { |r| rules_file << "#{r.chomp}\n" }
    end

    rules_file << "COMMIT\n"
  end

  file node['iptables-ng']["script_ipv#{new_resource.ip_version}"] do
    mode 00700
    content rules_file
  end
end
