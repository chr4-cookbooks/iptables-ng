require 'spec_helper'

describe 'iptables-ng::install' do
  describe 'debian' do

    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.automatic['platform_family'] = 'debian'
      end.converge(described_recipe)
    end

    it 'should remove ufw' do
      expect(chef_run).to remove_package('ufw')
    end
  end

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.automatic.merge!(JSON.parse(File.read('test/nodes/test.json')))
    end.converge(described_recipe)
  end
end
