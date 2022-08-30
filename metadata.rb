name             'iptables-ng'
maintainer       'Chris Aumann'
maintainer_email 'me@chr4.org'
license          'GPL-3.0-or-later'
description      'Installs/Configures iptables-ng'
source_url       'https://github.com/chr4-cookbooks/iptables-ng'
issues_url       'https://github.com/chr4-cookbooks/iptables-ng/issues'
version          '4.1.0'
chef_version     '>= 15.3'

%w(ubuntu debian
   redhat centos amazon suse scientific
   fedora gentoo arch).each do |os|
  supports os
end
