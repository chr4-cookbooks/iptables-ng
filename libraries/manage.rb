#
# Cookbook Name:: iptables-ng
# Module:: Iptables::Manage
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

require_relative 'helpers'

module Iptables
  module Manage
    module_function

    def actionable(resources = [])
      resources.reject { |r| r.action == :delete || r.should_skip?(r.action) }
    end

    # rubocop: disable AbcSize
    # rubocop: disable MethodLength
    def create_config(version, tables, run_context)
      config = [
        '# This file is managed by Chef.',
        '# Manual changes will be overwritten!'
      ]

      # Select actionable chains & rules from resource collection
      # Sort chains to reduce unnecessary reloads
      curr_chains = actionable(Iptables::Helpers.chains(run_context))
                    .sort { |a, b| a.name <=> b.name }

      # Sort rules to give user control over priority
      curr_rules = actionable(Iptables::Helpers.rules(run_context))
                   .select { |r| Array(r.ip_version).include?(version) }
                   .sort { |a, b| a.name <=> b.name }

      # Configure table rules
      tables.each do |table|
        # Initialize table
        config << "*#{table}"

        # Append config for table-appropriate chains & rules
        [curr_chains, curr_rules].each do |rc|
          rc.select { |r| r.table == table }.each do |c|
            config << c.to_s
          end
        end

        config << "COMMIT\n"
      end

      config.join("\n")
    end

    def restart_service(ip_version, conf, run_context)
      # Restart iptables service if available
      if conf["service_ipv#{ip_version}"]
        # Do not restart twice if the command is the same for ipv4 and ipv6
        return if conf['service_ipv4'] == conf['service_ipv6'] && ip_version == 6 # rubocop: disable LineLength

        Chef::Resource::Service.new(
          conf["service_ipv#{ip_version}"],
          run_context
        ).tap do |service|
          service.supports(status: true, restart: true)
          service.run_action(:enable)
          service.run_action(:restart)
        end
      # If no service is available, apply the rules manually
      else
        Chef::Log.info 'applying rules manually, as no service is specified'
        Chef::Resource::Execute.new(
          "iptables-restore for ipv#{ip_version}",
          run_context
        ).tap do |execute|
          execute.command("iptables-restore < #{conf['script_ipv4']}") if ip_version == 4 # rubocop: disable LineLength
          execute.command("ip6tables-restore < #{conf['script_ipv6']}") if ip_version == 6 # rubocop: disable LineLength
          execute.run_action(:run)
        end
      end
    end
    # rubocop: enable AbcSize
    # rubocop: enable MethodLength
  end
end
