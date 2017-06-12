
Puppet::Type.newtype(:ora_listener) do
  def self.module_name
    'ora_config'
  end

  desc <<-EOD
    This manages the oracle listener process.

    It makes sure the Oracle SQL*Net listener is running.

        ora_listener {'SID':
          ensure  => running,
          require => Exec['db_install_instance'],
        }

    The name of the resource *MUST* be the sid for which you want to start the listener.

  EOD

  newproperty(:ensure) do
    desc <<-EOD
      Whether a listener should be running.

      This is a required property without any defaults.
    EOD

    newvalue(:stopped, :event => :service_stopped) do
      provider.stop
    end

    newvalue(:running, :event => :service_started, :invalidate_refreshes => true) do
      provider.start
    end

    aliasvalue(:false, :stopped)
    aliasvalue(:true, :running)

    def retrieve
      provider.status
    end

    def sync
      event = super()

      property = @resource.property(:enable)
      if property
        val = property.retrieve
        property.sync unless property.safe_insync?(val)
      end

      event
    end
  end

  newparam(:name) do
    desc <<-EOD
      The sid of the listner to run.
    EOD

    isnamevar
  end
end
