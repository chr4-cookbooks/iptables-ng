#
# Cookbook Name:: iptables-ng
# Resource:: iptables_ng_rule
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

require 'chef/resource/lwrp_base'
require_relative 'helpers'

class Chef::Resource
  class IptablesNGRule < Chef::Resource::LWRPBase
    self.resource_name = :iptables_ng_rule
    provides :iptables_ng_rule

    actions :create, :delete
    default_action :create

    # Allow only dashes, underscores word characters and dots in rule name
    # as the name attribute will be used as a filename later.
    attribute :name, kind_of: String, name_attribute: true,regex: /^[-\w\.]+$/
    attribute :chain, kind_of: String, default: 'INPUT',
                      regex: IptablesNG::Helpers.chain_name_regexp
    attribute :table, kind_of: String, default: 'filter',
                      equal_to: IptablesNG::Helpers::TABLES
    attribute :rule,  kind_of: [Array, String],  default: []
    attribute :ip_version, kind_of: [Array, Integer], default: [4,6],
                           equal_to: [[4, 6], [4], [6], 4, 6]

    def to_s
      Array(rule).map { |r| "-A #{chain} #{r}" }.join("\n")
    end
  end
end
