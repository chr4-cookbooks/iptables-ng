#
# Cookbook:: iptables
# Resource:: rule
#
# Copyright:: 2012, Chris Aumann
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

unified_mode true

actions        :create, :create_if_missing, :delete
default_action :create

# Allow only dashes, underscores word characters and dots in rule name
# As the name attribute will be used as a filename later
attribute :name,       kind_of: String, name_attribute: true, regex: /^[-\w\.]+$/
# linux/netfilter/x_tables.h doesn't restrict chains very tightly.  Just a string token
# with a max length of XT_EXTENSION_MAXLEN (29 in all 3.x headers I could find)
attribute :chain,      kind_of: String, default: 'INPUT',  regex: /^[\w-]{1,29}$/
attribute :table,      kind_of: String, default: 'filter', equal_to: %w(filter nat mangle raw)
attribute :rule,       kind_of: [Array, String],  default: []
attribute :ip_version, kind_of: [Array, Integer], default: lazy { node['iptables-ng']['enabled_ip_versions'] }, equal_to: [[4, 6], [4], [6], 4, 6]

def path_for_chain
  "/etc/iptables.d/#{table}/#{chain}"
end

def path_for_ip_version(version)
  "#{path_for_chain}/#{name}.rule_v#{version}"
end

def paths
  Array(ip_version).map do |version|
    path_for_ip_version version
  end
end
