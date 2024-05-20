# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'generic/rhel9'
  config.vm.provider 'libvirt'

  config.trigger.after :up do |trigger|
    trigger.name = 'write_ssh_config'
    trigger.info = 'Writing SSH configuration to local data path'

    trigger.ruby do |env, _machine|
      File.open(File.join(env.local_data_path, 'ssh_config'), 'w') do |file|
        # Temporarily redirect STDOUT in order to grab the output of `vagrant ssh-config`
        stdout, $stdout = $stdout, file
        env.cli('ssh-config')
        $stdout = stdout
      end
    end
  end

  config.trigger.before :halt do |trigger|
    trigger.name = 'delete_ssh_config'
    trigger.info = 'Removing SSH configuration from local data path'

    trigger.ruby do |env, _machine|
      File.delete(File.join(env.local_data_path, 'ssh_config'))
    end
  end

  config.trigger.before :destroy do |trigger|
    trigger.name = 'unregister_rhsm'
    trigger.info = 'Unregistering the system from Red Hat Subscription Manager'

    trigger.run_remote = { inline: <<~SHELL }
      sudo subscription-manager unregister
    SHELL
  end

  config.vm.provision 'shell', inline: <<~SHELL
    if ! sudo subscription-manager status; then
      sudo subscription-manager register --username=#{ENV.fetch 'RHSM_USER'} \
           --password=#{ENV.fetch 'RHSM_PASSWORD'} --auto-attach
      sudo yum install -y insights-client
      sudo insights-client --register
    fi
    sudo yum update -y
  SHELL

  config.vm.provision 'ansible' do |ansible|
    ansible.compatibility_mode = '2.0'
    ansible.playbook = 'main.yml'
    ansible.galaxy_role_file = 'requirements.yml'
    ansible.extra_vars = { running_in_vagrant: true }
  end
end
