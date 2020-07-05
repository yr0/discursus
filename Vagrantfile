# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.forward_agent = true
  config.vm.synced_folder '.', '/vagrant', type: 'nfs'

  config.vm.define 'discursus' do |d|
    d.vm.box = 'ubuntu/xenial64'
    d.vm.network 'private_network', ip: '192.168.50.24'
  end

  config.vm.provider 'virtualbox' do |v|
    v.memory = 1028
    v.cpus = 2
  end

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'playbooks/playbook.yml'
  end
end
