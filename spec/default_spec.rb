require 'spec_helper'

describe 'iptables-ng::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic.merge!(JSON.parse(File.read('test/nodes/test.json')))
    end.converge(described_recipe)
  end

  %w( install configure manage ).each do |r|
    it "should include #{r} recipe" do
      expect(chef_run).to include_recipe("iptables-ng::#{r}")
    end
  end
end
