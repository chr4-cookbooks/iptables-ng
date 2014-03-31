require File.expand_path('../support/helpers', __FILE__)

describe 'iptables-ng::install' do
  include Helpers::TestHelpers

  it 'should set all default policies to ACCEPT' do
    file('/etc/iptables.d/filter/INPUT/default').must_include('ACCEPT [0:0]')
    file('/etc/iptables.d/filter/OUTPUT/default').must_include('ACCEPT [0:0]')
    file('/etc/iptables.d/filter/FORWARD/default').must_include('ACCEPT [0:0]')

    file('/etc/iptables.d/nat/OUTPUT/default').must_include('ACCEPT [0:0]')
    file('/etc/iptables.d/nat/PREROUTING/default').must_include('ACCEPT [0:0]')
    file('/etc/iptables.d/nat/POSTROUTING/default').must_include('ACCEPT [0:0]')

    file('/etc/iptables.d/mangle/INPUT/default').must_include('ACCEPT [0:0]')
    file('/etc/iptables.d/mangle/OUTPUT/default').must_include('ACCEPT [0:0]')
    file('/etc/iptables.d/mangle/FORWARD/default').must_include('ACCEPT [0:0]')
    file('/etc/iptables.d/mangle/PREROUTING/default').must_include('ACCEPT [0:0]')
    file('/etc/iptables.d/mangle/POSTROUTING/default').must_include('ACCEPT [0:0]')

    file('/etc/iptables.d/raw/OUTPUT/default').must_include('ACCEPT [0:0]')
    file('/etc/iptables.d/raw/PREROUTING/default').must_include('ACCEPT [0:0]')
  end

  it 'should not apply other iptables rules' do
    # Parse kernel version from uname
    kernel_version = shell_out('uname -r').stdout.split('-').first

    ipv4 = shell_out('iptables -L -n |wc -l')
    ipv4.stdout.must_include('8')

    # kernel <= 2.6.35 doesn't have the INPUT chain in nat table
    ipv4 = shell_out('iptables -L -n -t nat |wc -l')
    if Gem::Version.new(kernel_version) > Gem::Version.new('2.6.35')
      ipv4.stdout.must_include('11')
    else
      ipv4.stdout.must_include('8')
    end

    ipv4 = shell_out('iptables -L -n -t mangle |wc -l')
    ipv4.stdout.must_include('14')

    ipv4 = shell_out('iptables -L -n -t raw |wc -l')
    ipv4.stdout.must_include('5')
  end

  it 'should not apply other ip6tables rules' do
    ipv6 = shell_out('ip6tables -L -n |wc -l')
    ipv6.stdout.must_include('8')

    ipv6 = shell_out('ip6tables -L -n -t mangle |wc -l')
    ipv6.stdout.must_include('14')

    ipv6 = shell_out('ip6tables -L -n -t raw |wc -l')
    ipv6.stdout.must_include('5')
  end

  it 'should apply default policies in filter table' do
    ipv4 = shell_out('iptables -L -n')
    ipv4.stdout.must_include('Chain INPUT (policy ACCEPT)')
    ipv4.stdout.must_include('Chain OUTPUT (policy ACCEPT)')
    ipv4.stdout.must_include('Chain FORWARD (policy ACCEPT)')

    ipv6 = shell_out('ip6tables -L -n')
    ipv6.stdout.must_include('Chain INPUT (policy ACCEPT)')
    ipv6.stdout.must_include('Chain OUTPUT (policy ACCEPT)')
    ipv6.stdout.must_include('Chain FORWARD (policy ACCEPT)')
  end

  it 'should apply default policies in nat table' do
    # Parse kernel version from uname
    kernel_version = shell_out('uname -r').stdout.split('-').first

    ipv4 = shell_out('iptables -L -n -t nat')

    # kernel <= 2.6.35 doesn't have the INPUT chain in nat table
    if Gem::Version.new(kernel_version) > Gem::Version.new('2.6.35')
      ipv4.stdout.must_include('Chain INPUT (policy ACCEPT)')
    end
    ipv4.stdout.must_include('Chain OUTPUT (policy ACCEPT)')
    ipv4.stdout.must_include('Chain PREROUTING (policy ACCEPT)')
    ipv4.stdout.must_include('Chain POSTROUTING (policy ACCEPT)')
  end

  it 'should apply default policies in mangle table' do
    ipv4 = shell_out('iptables -L -n -t mangle')
    ipv4.stdout.must_include('Chain INPUT (policy ACCEPT)')
    ipv4.stdout.must_include('Chain OUTPUT (policy ACCEPT)')
    ipv4.stdout.must_include('Chain FORWARD (policy ACCEPT)')
    ipv4.stdout.must_include('Chain PREROUTING (policy ACCEPT)')
    ipv4.stdout.must_include('Chain POSTROUTING (policy ACCEPT)')

    ipv6 = shell_out('ip6tables -L -n -t mangle')
    ipv6.stdout.must_include('Chain INPUT (policy ACCEPT)')
    ipv6.stdout.must_include('Chain OUTPUT (policy ACCEPT)')
    ipv6.stdout.must_include('Chain FORWARD (policy ACCEPT)')
    ipv6.stdout.must_include('Chain PREROUTING (policy ACCEPT)')
    ipv6.stdout.must_include('Chain POSTROUTING (policy ACCEPT)')
  end

  it 'should apply default policies in raw table' do
    ipv4 = shell_out('iptables -L -n -t raw')
    ipv4.stdout.must_include('Chain OUTPUT (policy ACCEPT)')
    ipv4.stdout.must_include('Chain PREROUTING (policy ACCEPT)')

    ipv6 = shell_out('ip6tables -L -n -t raw')
    ipv6.stdout.must_include('Chain OUTPUT (policy ACCEPT)')
    ipv6.stdout.must_include('Chain PREROUTING (policy ACCEPT)')
  end

  it 'should enable iptables serices' do
    service(node['iptables-ng']['service_ipv4']).must_be_enabled if node['iptables-ng']['service_ipv4']
    service(node['iptables-ng']['service_ipv6']).must_be_enabled if node['iptables-ng']['service_ipv6']
  end
end
