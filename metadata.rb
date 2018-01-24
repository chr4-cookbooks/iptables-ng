name             'iptables-ng'
maintainer       'Chris Aumann'
maintainer_email 'me@chr4.org'
license          'GNU Public License 3.0'
description      'Installs/Configures iptables-ng'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/chr4-cookbooks/iptables-ng' if respond_to?(:source_url)
issues_url       'https://github.com/chr4-cookbooks/iptables-ng/issues' if respond_to?(:issues_url)
version          '3.0.1'

%w(ubuntu debian
   redhat centos amazon suse scientific
   fedora gentoo arch).each do |os|
  supports os
end
