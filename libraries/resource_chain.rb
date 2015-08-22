#
# Cookbook Name:: iptables
# Resource:: chain
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
  class IptablesNGChain < Chef::Resource::LWRPBase
    self.resource_name = :iptables_ng_chain
    provides :iptables_ng_chain

    actions :create, :delete
    default_action :create

    attribute :chain,  kind_of: String, name_attribute: true,
                       regex: IptablesNG::Helpers.chain_name_regexp
    attribute :table,  kind_of: String, default: 'filter',
                       equal_to: IptablesNG::Helpers.tables
    attribute :policy, kind_of: String, default: '- [0:0]'

    def to_s
      ":#{chain} #{policy}"
    end
  end
end
