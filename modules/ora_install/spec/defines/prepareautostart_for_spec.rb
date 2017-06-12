require 'spec_helper'
require 'shared_contexts'

describe 'ora_install::prepareautostart_for', :type => :define do

  # let(:facts) do
  #   {}
  # end
  let(:title) {'oracle'}

  let(:params) do
    {
    }
  end

  describe 'Solaris' do
    let(:facts) do
      {
        :kernel => 'SunOS',
        :operatingsystem => 'Solaris',
      }
    end

    it do
      is_expected.to contain_file('/etc/oracle')
         .with(
           'ensure'  => 'present',
           'mode'    => '0755',
           'owner'   => 'root'
         )
    end

    it do
      is_expected.to contain_file('/tmp/oradb_smf_oracle.xml')
        .with(
          'ensure' => 'present',
          'mode'   => '0755',
          'owner'  => 'root',
          'content' => /\/etc\/oracle/
        )
    end

    it do
      is_expected.to contain_exec('enable service oracle')
        .with(
          'command'   => 'svccfg -v import /tmp/oradb_smf_oracle.xml',
          'user'      => 'root',
          'logoutput' => 'on_failure',
          'path'      => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:',
          'unless'    => 'svccfg list | grep oracledatabase',
          'require'   => ['File[/tmp/oradb_smf_oracle.xml]','File[/etc/oracle]'],
        )
    end
  end

  describe 'Linux' do
    let(:facts) do
      {:kernel => 'Linux', :operatingsystem => 'RedHat'}
    end

    it do
      is_expected.to contain_file('/etc/init.d/oracle')
         .with(
           'content' => /LOCK_FILE=\/var\/lock\/subsys\/oracle/,
           'ensure'  => 'present',
           'mode'    => '0755',
           'owner'   => 'root'
         )
    end
    rhel_based = ['CentOS', 'RedHat', 'OracleLinux', 'SLES']
    deb_based = ['Ubuntu', 'Debian']
    rhel_based.each do |os|
      describe os do
        let(:facts) do
          {

            :kernel => 'Linux',
            :operatingsystem => os
          }

        end

        it do
          is_expected.to contain_exec('enable service oracle')
             .with(
               'command'   => "chkconfig --add oracle",
               'require'   => 'File[/etc/init.d/oracle]',
               'user'      => 'root',
               'unless'    => "chkconfig --list | /bin/grep \'oracle\'",
               'path'      => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:',
               'logoutput' => 'on_failure',
             )
        end
      end
    end
    deb_based.each do |os|
      describe os do
        let(:facts) do
          {
            :kernel => 'Linux',
            :operatingsystem => os
          }

        end

        it do
          is_expected.to contain_exec('enable service oracle')
               .with(
                 'command'   => "update-rc.d oracle defaults",
                 'require'   => 'File[/etc/init.d/oracle]',
                 'user'      => 'root',
                 'unless'    => "ls /etc/rc3.d/*oracle | /bin/grep \'oracle\'",
                 'path'      => '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:',
                 'logoutput' => 'on_failure',
               )
        end
      end
    end
  end
end
