require 'spec_helper'

describe Chef::Resource::IptablesNGChain do
  let(:chef_run) { ChefSpec::ServerRunner.new.converge('iptables-ng::default') }

  let(:dummy_chain) do
    Chef::Resource::IptablesNGChain.new('dummy', chef_run.run_context).tap do |r|
      r.chain 'FORWARD'
      r.table 'nat'
      r.policy 'DROP [0:0]'
    end
  end

  it 'generates a proper chain config' do
    expect(dummy_chain.to_s).to eq ':FORWARD DROP [0:0]'
  end
end
