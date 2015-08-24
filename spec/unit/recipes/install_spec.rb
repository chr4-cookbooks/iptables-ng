require 'spec_helper'

describe 'iptables-ng::install' do
  context 'debian' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'debian', version: '7.6')
        .converge(described_recipe)
    end

    %w( iptables iptables-persistent ).each do |pkg|
      it "should install #{pkg}" do
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'should remove ufw' do
      expect(chef_run).to remove_package('ufw')
    end
  end

  context 'modern rhel' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '7.0')
        .converge(described_recipe)
    end

    %w( iptables iptables-services ).each do |pkg|
      it "should install #{pkg}" do
        expect(chef_run).to install_package(pkg)
      end
    end
  end

  context 'ancient rhel' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '5.11')
        .converge(described_recipe)
    end

    %w( iptables iptables-ipv6 ).each do |pkg|
      it "should install #{pkg}" do
        expect(chef_run).to install_package(pkg)
      end
    end
  end

  context 'unknown platform' do
    let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'installs iptables' do
      expect(chef_run).to install_package('iptables')
    end
  end
end
