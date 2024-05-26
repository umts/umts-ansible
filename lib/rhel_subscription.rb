# frozen_string_literal: true

# This plugin configures the Red Hat Subscription Manager (RHSM) on the RHEL
# guest. It registers the system with RHSM using the provided credentials in
# the environment variables and installs the Insights client.
#
# The plugin also adds a trigger to unregister the system from RHSM before
# destroying the VM.
module RHELSubscription
  def self.configure(config)
    config.trigger.before :destroy do |trigger|
      trigger.name = 'unregister_rhsm'
      trigger.info = 'Unregistering the system from Red Hat Subscription Manager'

      trigger.on_error = :continue
      trigger.run_remote = { inline: <<~SHELL }
        sudo subscription-manager unregister
      SHELL
    end

    config.vm.provision 'shell', inline: <<~SHELL
      if ! sudo subscription-manager status; then
        sudo subscription-manager register --username=#{ENV.fetch 'RHSM_USER'} \
             --password=#{ENV.fetch 'RHSM_PASSWORD'} --auto-attach \
             --name='vagrant-rhel9-#{ENV.fetch 'RHSM_USER'}'
        sudo yum install -y insights-client
        sudo insights-client --register
      fi
      sudo yum update -y
    SHELL
  end
end
