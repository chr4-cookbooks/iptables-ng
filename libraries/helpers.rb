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

require 'chef/resource/directory'

module Iptables
  module Helpers
    SCRATCH_DIRECTORY ||= '/etc/iptables.d'

    module_function

    def create_scratch_directory(run_context)
      Chef::Resource::Directory.new(SCRATCH_DIRECTORY, run_context)
        .run_action(:create)
    end

    def create_table_directory(table, run_context)
      Chef::Resource::Directory.new(::File.join(SCRATCH_DIRECTORY, table), run_context)
        .run_action(:create)
    end
  end
end
