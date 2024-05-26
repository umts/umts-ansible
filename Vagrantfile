# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'lib/ssh_config'
require_relative 'lib/rhel_subscription'

Vagrant.configure('2') do |config|
  config.vm.box = 'generic/rhel9'

  SSHConfig.configure(config)
  RHELSubscription.configure(config)

  config.vm.provision 'ansible' do |ansible|
    ansible.compatibility_mode = '2.0'
    ansible.playbook = 'main.yml'
    ansible.galaxy_role_file = 'requirements.yml'
    ansible.extra_vars = { running_in_vagrant: true }
  end
end
