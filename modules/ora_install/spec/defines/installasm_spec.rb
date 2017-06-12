require 'spec_helper'

describe 'ora_install::installasm', :type => :define do

  let(:test_params) {{}}
  let(:test_facts)  {{}}
  let(:params) {{
    :version                   => '11.2.0.4',
    :file                      => 'p13390677_112040_Linux-x86-64_3of7.zip',
    :grid_type                 => 'HA_CONFIG',
    :grid_base                 => '/app/grid',
    :grid_home                 => '/app/grid/product/11.2/grid',
    :remote_file               => false,
    :download_dir              => '/install',
    :puppet_download_mnt_point => '/software',
    :user_base_dir             => '/home',
    :user                      => 'grid',
    :group                     => 'asmdba',
    :group_install             => 'oinstall',
    :group_oper                => 'asmoper',
    :group_asm                 => 'asmadmin',
    :sys_asm_password          => 'Welcome01',
    :asm_monitor_password      => 'Welcome01',
  }.merge(test_params)}

  let(:facts) {{ :operatingsystem           => 'CentOS' ,
                 :kernel                    => 'Linux',
                 :operatingsystemmajrelease => '6',
                 :osfamily                  => 'RedHat' }.merge(test_facts)}
  let(:title) {'test_asm_create'}

  describe "No valid grid_base" do
    let(:test_params) {{
      :grid_base => 1,
    }}
    it { is_expected .to raise_error(Puppet::Error, /You must specify an grid_base/)}
  end

  describe "No valid grid_home" do
    let(:test_params) {{
      :grid_home => 1,
    }}
    it { is_expected .to raise_error(Puppet::Error, /You must specify an grid_home/)}
  end

  describe "wrong grid version" do
    let(:test_params) {{
      :version => '11.2.0.1',
    }}
    it { is_expected .to raise_error(Puppet::Error, /Unrecognized database grid install version, use 11.2.0.4, 12.1.0.1 or 12.1.0.2/)}
  end

  describe "wrong OS" do
    let(:test_facts) {{
      :operatingsystem => 'Windows' ,
      :kernel          => 'Windows',
      :osfamily        => 'Windows'
     }}
     it { is_expected .to raise_error(Puppet::Error, /Unrecognized operating system, please use it on a Linux or SunOS host/)}
  end

  describe "wrong grid type" do
    let(:test_params) {{
      :grid_type => 'XXXX',
    }}
    it { is_expected .to raise_error(Puppet::Error, /Unrecognized database grid type, please use CRS_CONFIG|HA_CONFIG|UPGRADE/)}
  end

  describe "wrong disk_au_size" do
    let(:test_params) {{
      :disk_au_size => 200,
    }}
    it { is_expected .to raise_error(Puppet::Error, /invalid disk_au_size/)}
  end

  describe "cluster name specfied" do
    describe "no scan name specfied" do
      let(:test_params) {{
        :cluster_name => 'test',
      }}
      it { is_expected .to raise_error(Puppet::Error, /You must specify scan_name if cluster_name is defined/)}
    end

    describe "no scan port specfied" do
      let(:test_params) {{
        :cluster_name => 'test',
        :scan_name    => 'scan'
      }}
      it { is_expected .to raise_error(Puppet::Error, /You must specify scan_port if cluster_name is defined/)}
    end

    describe "no cluster_nodes port specfied" do
      let(:test_params) {{
        :cluster_name => 'test',
        :scan_name    => 'scan',
        :scan_port    => 10,
      }}
      it { is_expected .to raise_error(Puppet::Error, /You must specify cluster_nodes if cluster_name is defined/)}
    end

    describe "no network_interface_list specfied" do
      let(:test_params) {{
        :cluster_name  => 'test',
        :scan_name     => 'scan',
        :scan_port     => 10,
        :cluster_nodes => 'a,b'
      }}
      it { is_expected .to raise_error(Puppet::Error, /You must specify network_interface_list if cluster_name is defined/)}
    end

    describe "no storage_option specfied" do
      let(:test_params) {{
        :cluster_name           => 'test',
        :scan_name              => 'scan',
        :scan_port              => 10,
        :cluster_nodes          => 'a,b',
        :network_interface_list => 'a,b,c',
      }}
      it { is_expected .to raise_error(Puppet::Error, /You must specify storage_option if cluster_name is defined/)}
    end

    describe "invalid storage_option specfied" do
      let(:test_params) {{
        :cluster_name           => 'test',
        :scan_name              => 'scan',
        :scan_port              => 10,
        :cluster_nodes          => 'a,b',
        :network_interface_list => 'a,b,c',
        :storage_option         => 'XX'
      }}
      it { is_expected .to raise_error(Puppet::Error, /storage_option must be either ASM_STORAGE of FILE_SYSTEM_STORAGE/)}
    end

  end

  describe 'bash_profile' do
    context 'set to true' do
      let(:test_params) {{
        :bash_profile => true,
      }}
      it { is_expected.to contain_file('/home/grid/.bash_profile')}
    end

    context 'set to false' do
      let(:test_params) {{
        :bash_profile => false,
      }}
      it { is_expected.not_to contain_file('/home/grid/.bash_profile')}
    end
  end

end
