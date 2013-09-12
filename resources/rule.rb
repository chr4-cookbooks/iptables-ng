#
# Cookbook Name:: iptables
# Resource:: rule
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

actions        :create, :delete
default_action :delete

attribute :name,       kind_of: String,           name_attribute: true
attribute :table,      kind_of: String,           default: 'filter'
attribute :chain,      kind_of: String,           default: 'INPUT'
attribute :rule,       kind_of: [Array, String],  default: []
attribute :ip_version, kind_of: [Array, Integer], default: [4, 6]
