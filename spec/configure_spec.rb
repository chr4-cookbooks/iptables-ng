require 'spec_helper'

describe 'iptables-ng::configure' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic.merge!(JSON.parse(File.read('test/nodes/test.json')))
    end.converge(described_recipe)
  end

  it 'should apply rules from node definition' do
    expect(chef_run).to create_iptables_ng_rule('test1-filter-INPUT-attribute-rule')
      .with(
        chain:      'INPUT',
        table:      'filter',
        rule:       '--protocol tcp --dport 22 --match state --state NEW --jump ACCEPT',
        ip_version: [4, 6],
      )

    expect(chef_run).to create_iptables_ng_rule('test2-filter-INPUT-attribute-rule')
      .with(
        chain:      'INPUT',
        table:      'filter',
        rule:       '--protocol tcp --dport 80 --match state --state NEW --jump DROP',
        ip_version: 4,
      )
  end

  it 'should apply default policies' do
    expect(chef_run).to create_iptables_ng_chain('default-policy-filter-INPUT')
    expect(chef_run).to create_iptables_ng_chain('default-policy-filter-OUTPUT')
    expect(chef_run).to create_iptables_ng_chain('default-policy-filter-FORWARD')
    expect(chef_run).to create_iptables_ng_chain('default-policy-nat-OUTPUT')
    expect(chef_run).to create_iptables_ng_chain('default-policy-nat-PREROUTING')
    expect(chef_run).to create_iptables_ng_chain('default-policy-nat-POSTROUTING')
    expect(chef_run).to create_iptables_ng_chain('default-policy-mangle-INPUT')
    expect(chef_run).to create_iptables_ng_chain('default-policy-mangle-OUTPUT')
    expect(chef_run).to create_iptables_ng_chain('default-policy-mangle-FORWARD')
    expect(chef_run).to create_iptables_ng_chain('default-policy-mangle-PREROUTING')
    expect(chef_run).to create_iptables_ng_chain('default-policy-mangle-POSTROUTING')
    expect(chef_run).to create_iptables_ng_chain('default-policy-raw-OUTPUT')
    expect(chef_run).to create_iptables_ng_chain('default-policy-raw-PREROUTING')
  end
end
