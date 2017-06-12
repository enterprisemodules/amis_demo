require 'spec_helper'

describe 'ora_install::database', :type => :define do
  let(:test_params) {{}}
  let(:test_facts)  {{}}
  let(:params) {{
    :oracle_base   => '/oracle',
    :oracle_home   => '/oracle/product/11.2/db',
    :version       => '11.2',
    :user          => 'oracle',
    :group         => 'dba',
    :download_dir  => '/install',
    :action        => 'create',
  }.merge(test_params)}

  let(:facts) {{ :operatingsystem => 'CentOS' ,
                 :kernel          => 'Linux',
                 :osfamily        => 'RedHat' }.merge(test_facts)}
  let(:title) {'testDb_Create'}

  describe "wrong template_type" do
    let(:test_params) {{
      :template_type =>'wrong',
      :template      => 'a.dbt'
    }}
    it { is_expected .to raise_error(Puppet::Error, /parameter template_type value wrong is invalid/)}
  end

  describe "wrong database version" do
    let(:test_params) {{
      :version =>'13.1'
    }}
    it {is_expected. to raise_error(Puppet::Error, /Unrecognized version/)}
  end

  describe "wrong OS" do
    let(:test_facts) {{
      :operatingsystem => 'Windows' ,
      :kernel          => 'Windows',
      :osfamily        => 'Windows'
     }}

    it {is_expected.to raise_error(Puppet::Error, /Unrecognized operating system/)}
  end

  describe "wrong action" do
    let(:test_params) {{
      :action =>'xxxxx'
    }}
    it {is_expected.to raise_error(Puppet::Error, /Unrecognized database action/)}
  end

  describe "wrong database_type" do
    let(:test_params) {{
      :database_type =>'XXXX'
    }}
    it {is_expected.to raise_error(Puppet::Error, /Unrecognized database_type/)}
  end

  describe "wrong em_configuration" do
    let(:test_params) {{
      :em_configuration => "XXXX",
    }}
    it {is_expected.to raise_error(Puppet::Error, /Unrecognized em_configuration/)}
  end

  describe "wrong storage_type" do
    let(:test_params) {{
      :storage_type => "XXXX",
    }}
    it {is_expected.to raise_error(Puppet::Error, /Unrecognized storage_type/)}
  end

  describe "container database on 11.2" do
    let(:test_params) {{
      :container_database => true,
      :version            => '11.2',
    }}
    it {is_expected.to raise_error(Puppet::Error, /container or pluggable database is not supported on version 11.2/)}
  end
  describe "init params" do

    describe "specified as a String" do
      let(:test_params) {{
        :init_params => "a=1,b=2"
      }}

      it {is_expected.not_to raise_error()}
    end

    describe "specified as a Hash" do
      let(:test_params) {{
        :init_params => {'a' => 'a', 'b' => 'b'}
      }}

      it {is_expected.not_to raise_error()}
    end

    describe "specified as an Array" do
      let(:test_params) {{
        :init_params => [1,2,3,4,5]
        # :init_params=> [1,2,3,4,5]
      }}
      it {is_expected.to raise_error(Puppet::Error, /init_params only supports a String or a Hash as value type/)}
    end
  end
end
