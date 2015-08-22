#
# Cookbook Name:: iptables-ng
# Provider:: iptables_ng_conf
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

require 'chef/provider/lwrp_base'

class Chef::Provider
  class IptablesNGConf < Chef::Provider::LWRPBase
    use_inline_resources

    provides :iptables_ng_chain
    provides :iptables_ng_rule

    def whyrun_supported?
      true
    end

    [:create, :delete].each do |a|
      action a do
        r = new_resource

        include_recipe 'iptables-ng::install' unless a == :delete

        path = ::File.join(Chef::Config[:file_cache_path] || '/tmp', r.name)

        f = file path do
          content r.to_s
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
