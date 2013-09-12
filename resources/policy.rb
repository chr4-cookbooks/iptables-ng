#
# Cookbook Name:: iptables
# Resource:: policy
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

actions        :create, :create_if_missing, :delete
default_action :create

attribute :chain,  kind_of: String, name_attribute: true
attribute :table,  kind_of: String, default: 'filter'
attribute :policy, kind_of: String, default: 'ACCEPT [0:0]'


def initialize(*args)
  super
  @action = :create

  # Include iptables-ng::install recipe
  @run_context.include_recipe('iptables-ng::install')
end
