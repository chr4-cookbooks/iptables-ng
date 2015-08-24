require 'spec_helper'

describe 'iptables-ng::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  %w( install configure manage ).each do |r|
    it "should include iptables-ng::#{r}" do
      expect(chef_run).to include_recipe("iptables-ng::#{r}")
    end
  end
end
