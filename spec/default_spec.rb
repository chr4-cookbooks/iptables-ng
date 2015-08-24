require 'spec_helper'

describe 'iptables-ng::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic.merge!(JSON.parse(File.read('test/nodes/test.json')))
    end.converge(described_recipe)
  end

  it 'should include iptables-ng::install' do
    expect(chef_run).to include_recipe('iptables-ng::install')
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
end
