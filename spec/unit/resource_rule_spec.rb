require 'spec_helper'

describe Chef::Resource::IptablesNGRule do
  let(:chef_run) { ChefSpec::ServerRunner.new.converge('iptables-ng::default') }

  let(:dummy_rule) do
    Chef::Resource::IptablesNGRule.new('dummy', chef_run.run_context).tap do |r|
      r.chain 'INPUT'
      r.table 'filter'
      r.rule '-j ACCEPT'
    end
  end

  it 'generates a proper chain config' do
    expect(dummy_rule.to_s).to eq '--append INPUT -j ACCEPT'
  end
end
