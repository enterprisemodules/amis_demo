require 'pathname'
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent)
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.parent.parent.parent.parent + 'easy_type' + 'lib')
require 'easy_type'
require 'puppet_x/enterprisemodules/oracle/access'
require 'puppet_x/enterprisemodules/oracle/title_parser'
require 'puppet/type/ora_schema_definition/version'
require 'puppet_x/enterprisemodules/oracle/default_sid'

Puppet::Type.newtype(:ora_schema_definition) do
  include EasyType
  include Puppet_X::EnterpriseModules::Oracle::Access
  extend Puppet_X::EnterpriseModules::Oracle::TitleParser
  include Puppet_X::EnterpriseModules::Oracle::DefaultSid

  desc <<-EOD
    This resource allows you to manage a schema definition. This includes all tables, indexes and other DDL that is needed for your application.

        ora_schema_definition{'MYAPP':
            ensure      => '1.0.0',
            schema_name => 'MYAPP,
            password    => 'verysecret',
            source_path => '/opt/stage/myapp/sql',
        }

    In this example we tell Puppet, we need schema version `1.0.0` for `MYAPP` in the database. In layman's terms
    now the following things will happen:

    - The Puppet type will log in to the database using username `myapp` and the very secret password and it will look at the version of the schema already available.
    - If the current version is lower than the specified version, Puppet will execute the upgrade SQL scripts in the source path until the correct version is reached.
    - If the current version is higher than the requested version, Puppet will execute the downgrade scripts until the requested version is reached.

    ## Schema version?

    What is this concept of a schema version? To administer the current version, Puppet uses a table called `SCHEMA_VERSION`.
    Here is the definition of this table:

        CREATE TABLE schema_version
        (  id                NUMBER
          ,application       VARCHAR2(255)
          ,version           VARCHAR2(255)
          ,description       VARCHAR2(255)
          ,installation_time TIMESTAMP(6)
        );

    Puppet uses this table to store the history of all schema versions applied. If the table doesn't exists, Puppet will
    create it for you. Using this information, Puppet can tell what the state of the current schema in the database is.
    Puppet creates this table for every single schema/user you manage. This means, you can have multiple schemas with
    different versions in your database.

    ## What about these upgrade and downgrade scripts.

    In order for Puppet to do it's magic, the upgrade and downgrade scripts, need to have specific names.
    Here is a listing of some upgrade scripts:

        upgrades/0000_myapp_0.0.1_initial-schema.sql
        upgrades/0001_myapp_0.0.2_add-user-table.sql
        upgrades/0002_myapp_0.1.0_initial-release.sql

    As you can see, all the file names have the following structure:

    - a four-digit sequence number
    - application name
    - version number
    - description

    All fields are separated by an underscore. The upgrade scripts contain all SQL statements needed to upgrade
    the database schema to the desired state. In general upgrade scripts contain statements to create tables and
    indexes and add or remove columns, but you can also insert data into the lookup-tables or create database packages.

    The `downgrades` directory contains scripts with the same names. The downgrade scripts contain the SQL statements
    needed to put the database in the state it was before. So if you add a column in an upgrade script, you'll have
    to remove this column in the downgrade script.

  EOD

  to_get_raw_resources do
    []
  end

  on_create do
    parameters[:source_path].process
    FileUtils.chmod_R(0o777, source_path) # So oracle and grid users can access them
    provider.upgrade_to(self[:ensure])
    parameters[:source_path].clean
    nil
  end

  on_modify do
    parameters[:source_path].process
    FileUtils.chmod_R(0o777, source_path) # So oracle and grid users can access them
    if ::Version.new(self[:ensure]) > provider.ensure
      provider.upgrade_to(self[:ensure])
    else
      provider.downgrade_to(self[:ensure])
    end
    parameters[:source_path].clean
    nil
  end

  on_destroy do
    provider.class.destroy(self)
    nil
  end

  map_title_to_sid(:schema_name)

  parameter :name
  parameter :schema_name
  parameter :sid
  property  :ensure
  parameter :source_path
  parameter :tmp_dir
  parameter :parameters
  parameter :password
  parameter :reinstall

  ora_autorequire(:ora_user, :schema_name)
end
