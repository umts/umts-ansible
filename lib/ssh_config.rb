# frozen_string_literal: true

# This module creates a trigger that writes the SSH configuration to a file in the local data path
# when the machine is brought up. The trigger also deletes the file when the machine is halted.
# The SSH configuration can then be used by other tools that require it, such as `rsync` or `scp`.

# Usage:
#   Vagrant.configure('2') do |config|
#     config.vm.box = 'ubuntu/focal64'
#     config.vm.provision :shell, path: 'provision.sh'
#
#     SSHConfig.configure(config)
#   end

# The SSH configuration will be written to the file `ssh_config` in the local data path.
# The local data path can be accessed from the host machine at
# `.vagrant/machines/default/virtualbox` in the project directory.
module SSHConfig
  def self.configure(config)
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
        ssh_config_file = File.join(env.local_data_path, 'ssh_config')
        File.delete(ssh_config_file) if File.exist?(ssh_config_file)
      end
    end
  end
end
