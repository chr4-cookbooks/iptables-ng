#
# Cookbook Name:: iptables-ng
# Module:: Iptables::Helpers
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

module Iptables
  module Helpers
    TABLES ||= %w( raw mangle nat filter )

    module_function

    # linux/netfilter/x_tables.h doesn't restrict chains very tightly,
    # just a string token with a max length of XT_EXTENSION_MAXLEN
    # (29 in all 3.x headers I could find).
    def chain_name_regexp
      /^[-\w\.]+$/
    end

    def resources(resource, run_context)
      run_context.resource_collection.select do |r|
        r.is_a?(resource)
      end
    end

    def chains(run_context)
      resources(Chef::Resource::IptablesNGChain, run_context)
    end

    def rules(run_context)
      resources(Chef::Resource::IptablesNGRule, run_context)
    end
  end
end
