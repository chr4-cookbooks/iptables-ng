#
# Cookbook Name:: iptables-ng
# Attributes:: rules
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

# Set up default policies
default['iptables-ng'].tap do |ip|
  ip['rules'].tap do |rules|
    # Configure filter table chain policies
    rules['filter'].tap do |filter|
      filter['INPUT']['default'] = 'ACCEPT [0:0]'
      filter['OUTPUT']['default'] = 'ACCEPT [0:0]'
      filter['FORWARD']['default'] = 'ACCEPT [0:0]'
    end

    # Configure nat table chain policies
    rules['nat'].tap do |nat|
      nat['OUTPUT']['default'] = 'ACCEPT [0:0]'
      nat['PREROUTING']['default'] = 'ACCEPT [0:0]'
      nat['POSTROUTING']['default'] = 'ACCEPT [0:0]'
    end

    # Configure mangle table chain policies
    rules['mangle'].tap do |mangle|
      mangle['INPUT']['default'] = 'ACCEPT [0:0]'
      mangle['OUTPUT']['default'] = 'ACCEPT [0:0]'
      mangle['FORWARD']['default'] = 'ACCEPT [0:0]'
      mangle['PREROUTING']['default'] = 'ACCEPT [0:0]'
      mangle['POSTROUTING']['default'] = 'ACCEPT [0:0]'
    end

    # Configure raw table chain policies
    rules['raw'].tap do |raw|
      raw['OUTPUT']['default'] = 'ACCEPT [0:0]'
      raw['PREROUTING']['default'] = 'ACCEPT [0:0]'
    end
  end
end
