require 'spec_helper'

describe 'iptables-ng::install' do
  describe 'debian' do

    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.automatic['platform_family'] = 'debian'
      end.converge(described_recipe)
    end

    it 'should remove ufw' do
      expect(chef_run).to remove_package('iptables-ng::install - ufw package')
    end
  end

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic.merge!(JSON.parse(File.read('test/nodes/test.json')))
    end.converge(described_recipe)
  end

  it 'should include iptables-ng::manage' do
    expect(chef_run).to include_recipe('iptables-ng::manage')
  end

  it 'should create directory for chains' do
    expect(chef_run).to create_directory('/etc/iptables.d/filter')
    expect(chef_run).to create_directory('/etc/iptables.d/nat')
    expect(chef_run).to create_directory('/etc/iptables.d/mangle')
    expect(chef_run).to create_directory('/etc/iptables.d/raw')
  end

  it 'should apply default policies' do
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-filter-INPUT')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-filter-OUTPUT')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-filter-FORWARD')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-nat-OUTPUT')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-nat-PREROUTING')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-nat-POSTROUTING')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-mangle-INPUT')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-mangle-OUTPUT')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-mangle-FORWARD')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-mangle-PREROUTING')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-mangle-POSTROUTING')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-raw-OUTPUT')
    expect(chef_run).to create_if_missing_iptables_ng_chain('default-policy-raw-PREROUTING')
  end
end
