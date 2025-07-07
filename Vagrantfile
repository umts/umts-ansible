# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'lib/ssh_config'
require_relative 'lib/rhel_subscription'

Vagrant.configure('2') do |config|
  config.vm.define 'web', default: true do |web|
    web.vm.network 'private_network', ip: '10.19.69.10'
    web.vm.box = 'generic/rhel9'

    SSHConfig.configure(web)
    RHELSubscription.configure(web)

    web.vm.provision 'ansible' do |ansible|
      ansible.compatibility_mode = '2.0'
      ansible.playbook = 'main.yml'
      ansible.galaxy_role_file = 'requirements.yml'
      ansible.groups = {
        'umts_servers' => ['web'],
        'rails_apps' => ['web'],
        'umaps_rails' => ['web']
      }
      ansible.extra_vars = {
        running_in_vagrant: true,
        rails_database: {
          database: 'application_production',
          host: '10.19.69.20',
          port: 3306,
          username: 'my_application',
          password: 'PASSWORD'
        }
      }
    end
  end

  config.vm.define 'db' do |db|
    db.vm.network 'private_network', ip: '10.19.69.20'
    db.vm.box = 'bento/ubuntu-24.04'

    db.vm.provision 'shell', path: 'db-server.sh'
  end
end
