History
========

### 10-03-2017 Version 2.3.4
- [ora_tablespace] Add support for encrypted tablespaces
- [ora_database] Don't remove directories when pluggable database creaetion fails Closes #97
- [ora_user] Fix double identified by issue. Closes #90
- [ora_database] Add default value for temporary_tablespace in template
- [ora_user] Fix bug related to current_hashed_password
- [ora_feature_usage] Add where clause
- [ora_feature_usage] Remove where condition and cleanup
- [ora_feature_usage] Add type
- [ora_home_option] Remove debug statements

### 28-02-2017 Version 2.3.3
- [ora_database] sqlplus variable sysPassword and systemPassword only set for container databases. Closes #96

### 28-02-2017 Version 2.3.2
- [core] Fix name clash on Hash
- [ora_home_options] Initial version
- [ora_trigger] Fix problems with triggers containing special characters
- [ora_init_param] Extract the hex_to_raw function from ora_init_param
- [ora_setting] Ensure correct loading on PE

### 08-02-2017 Version 2.3.1
- [ora_service] Fix Oracle12 provider
- [ora_tablespace] Fix unit tests
- [ora_profile] Fix spec
- [ora_tablespace] Fix next property
- [ora_asm_diskgroup] Fix properties
- [ora_asm_directory]  Fix used sid parameter

### 30-01-2017 Version 2.3.0
- [ora_role] Add container property
- [ora_service] Add confinement to have Oracle running
- [ora_database] Always uppercase database names
- [ora_user] autorequire tablespaces in quotas
- [ora_user] Allow container based profiles
- [ora_profile] Allow container based profiles
- [core] Allow container based grants
- [core] Allow passwordless connect to normal and containers
- [ora_service] Remove default value for preferred_instances
- [ora_service] Add support for services in pluggable database
- [ora_service] Service name must be a full qualified name
- [ora_service] Only provide default for preferred_instances when cluster
- [facts] Make ASM facts compatible with older puppet versions
- [ora_database] Create oratab entry for pdb
- [ora_database] Fix connect string for pdb
- [ora_service] Make properties case-insensitive
- [core] Better handling of default sids for all database types
- [ora_database] Handle cluster databases
- [core] include path in all informational and warning messages
- [ora_database] Fix setting the default when only one database is present
- [ora_database] Fix archiving detection. And fix settings name when cluster
- [ora_service] Make casing of properties less strict
- [ora_service] Make it work in first run when Oracle will be installed
- [core] include resource name in warnings and info messages
- [ora_database] Allow modification of archive mode
- [ora_setting] Reset default on other entries when new default added
- [ora_database] Compatible for Oracle 11
- [core] Make grant_property ruby 1.8.7 compatible
- [core] Make settings ruby 1.8.7. compatible
- [information] Make information block Oracle 11 compatible
- [core] No permissions on /root for os_user
- [facts] Fix is_container_db fact
- [facts] Don’t allow the facts to import information into Object
- [ora_object_grant] Add container scope to sql statement
- [core] Use container only on Oracle12 versions
- [core] Fix containerdb information
- [ora_object_grant] Add container property
- [ora_profile] Used versioned statement for to_get_raw_resources
- [ora_user] Add the container property
- [ora_profile] Add support for container property
- [facts] Add plugable db facts
- [ora_database] Silently ignore archivelog, autostart and force_logging for pluggable databases
- [ora_database] Fix several issues with pluggable databases
- [facts] Add  support for array and record facts. Also add support for asm, and mgmt facts
- [parser] Add functions generated_password and available_sids
- [ora_init_param] fix default for_sid implementation
- [ora_init_param] Fix default for_sid when SPFILE parameter
- [core] Add support for setting the os_user in the ora_settings
- [ora_init_param] Start using the new map_titles_to_attributes
- [core] Start using the new map_titles_to_attributes
- [providers] confine to work only when ora_settings.yaml is present
- [ora_asm_directory] Fix typo
- [core] Better error reporting when an error occurs in a command. Closes #76
- [core] No default for username
- [ora_role] Allow updates of roles
- [ora_object_grant] Fix typo in the documentation
- [ora_user] Better password generation
- [ora_settings] Display message after generate
- [core] Fix output logging in relation with error handling
- [ora_database] Remove sid as parameter
- [core] MAke adm_sid and sid namevars
- [ora_object_audit] Initial implementation
- [ora_statement_audit] Added intial implementation
- [ora_user] Remove default for profile
- [core] Fix issue when password is empty
- [ora_settings] Implement conversion utility
- [core] Implement output logging. Closes #87
- [ora_database] Generate random passwords and don't fail if they are not specified
- [ora_service] Fix creation of non-clustered service
- [ora_database] Make force logging manageable
- [ora_database] Make autostart manageable
- [ora_database] Call the perl from the ORACLE_HOME
- [ora_database] Added options parameter
- [ora_database] Made container database creation
- [ora_database] Add support for pluggable databases initial commit
- [ora_database] Fix file_name_convert in template
- [ora_database] Move to simple provider
- [ora_database] Manage ora_settings entry on create and destroy
- [ora_database] Fix logging for destroy operations
- [core] Fix database running detection
- [core] Fix variable expansion in sql command
- [ora_setting] Use the easy_type yaml_type as implementation.
- [ora_database] Create container database initial commit
- [core] Add default property and remove oracle_sid property
- [ora_database] Make ora_database manageable
- [core] Remove all references to oratab which moved to ora_setting or were not needed anymore
- [core] Refactor access to settings
- [core] Removed sysdba and added syspriv property to ora_setting and other stuff
- [ora_databae] Add pluggable property, true boolean properties and don't fail on invalid sid(for remote connections
- [ora_setttings] Initial implementation
- [ora_object_grant] Add support for grants with grant option
- [ora_role] Added support for grants_with_admin, granted_with_admin and revoked_with_admin
- [ora_user] Added support for grants_with_admin, granted_with_admin and revoked_with_admin
- [core] Added support for with_admin grants
- [ora_role] Added granted and revoked property
- [ora_user] Added granted and revoked property
- [ora_user] Added property revoked and granted
- [ora_service] Port to new easy_type
- [facts] Allow all sorts of structures facts
- [ora_service] Also include the last service
- [core] Remove some leftovers from command_builder
- [ora_asm_volume]  use new easy_type features
- [ora_asm_diskgroup]  use new easy_type features
- [ora_database]   use new easy_type features
- [ora_trigger] use new easy_type features
- [ora_thread] use new easy_type features
- [ora_synonym] use new easy_type features
- [ora_service] use new easy_type features
- [ora_schema_definition]  use new easy_type features
- [ora_record]  use new easy_type features
- [ora_profile]  use new easy_type features
- [ora_package]  use new easy_type features
- [ora_object_grant] use new easy_type features
- [ora_directory] use new easy_type features
- [ora_init_param]  use new easy_type features
- [ora_role]  use new easy_type features
- [ora_asm_disk] Fix handling of unsorted entries
- [ora_asm_disk] Fix handling of unsorted entries
- [ora_tablespace] use new easy_type features
- [ora_service] Set default value to running
- [ora_service] Make the current instances the default for preferred_instances
- [ora_database] Add support for report_errors parameter
- [ora_service] Use features to decide on provider
- [core] Add Oracle11 and Oracle 12 features
- [ora_asm_volume] Fix usage of asm_sid
- [ora_asm_diskgroup] Fix usage of asm_sid
- [ora_service] Implementation of all cluster properties
- [ora_service] index shows all cluster properties
- [ora_service] Add support for all srvmgr properties
- [ora_service] Fix issue in detecting partly stopped services
- [ora_profile] Support K/M etc on private_sga property. Closes #74
- [ora_profile] Fix casing problem. Closes #75
- [ora_service] Add support for running property
- [ora_asm_diskgroup] Fix issue in ordering of disk_group
- [ora_exec] Trigger refresh always when no unless is specified
- [core] use base sid for determining autorequires
- [ora_init_param] Fix parameters with values containing , and other exotic characters
- [core] remove bare named elements on autorequire when sid is set
- [ora_trigger] Fix autorequire
- [ora_package] Fix autorequires
- [ora_trigger] Fix autorequires
- [ora_record] Fix autorequires
- [ora_schema_definition] Fix autorequires
- [ora_synonym] Fix autorequires
- [ora_object_grant] Fix autorequires
- [ora_exec] Fix autorequires
- [ora_user] Fix autorequires
- [core] Added ora_autorequire function for compex autorequires
- [ora_record] Fix documentation
- [ora_exec] Fixed respecting the unless parameter on refresh
- [ora_asm_diskgroup] Fix when removing multiple diskgroups
- [ora_asm_diskgroup] Fix when adding multiple diskgroups
- [ora_tablespace] Add support for resizing smallfile tablespaces
- [ora_asm_diskgroup] Fix multiple issues
- [ora_asm_disk] Add acceptance tests
- [core] Make vagrant development bxo same as acceptance test box
- [ora_user] Better implementation of the default_roles property
- [ora_user] Fix ordering issue on default_roles property
- [ora_user] Improved handling of default roles value ALL and NONE
- [ora_sql_schema_definition] Fix error because of non existing directory
- [core] Move validation of sid down in stack
- [ora_schema_definition] Add support for remote files in source_path
- [ora_asm_diskgroup] Fix ruby 1.8.7 problem
- [ora_schema_version] Add better documentation
- [ora_schema_definition] Add default empty value for parameters
- [ora_schema_definition] Better error message when file name syntax in incorrect.
- [ora_record] Add autorequire for user
- [ora_package] Add autorequire for user
- [ora_exec] Add autorequire for user
- [ora_database] Fixed problems in logfile_groups
- [ora_user] Fix missing quote in docs
- [ora_asm_diskgroup] Add update support

### 12-09-2016 Version 2.2.7
- [ora_database] Support Oracle Managed Files for log file groups

### 08-09-2016 Version 2.2.6
- [ora_database] Fix multifile fixed number log groups
- [docs] Update docs

### 07-09-2016 Version 2.2.5
- [ora_database] Add support for multiple log files per loggroup
- [ora_trigger] Add support for (non)editionable create scripts
- [ora_package] Add support for (non)editionable create scripts

### 26-08-2016 Version 2.2.4
- [ora_init_param] Update content quoting to latest version of easy_type
- [ora_exec] Add support for mark_as_error parameter,
- [ora_package] Add difference reporting on source
- [ora_package] Update the documentation
- [ora_trigger] Initial implementation

### 20-08-2016 Version 2.2.3
- [ora_init_param] Handle quites in the values
- [ora_package] Fix provider name
- [core] Add support to manage mgnt database
- [core] Fix all usage of template function
- [ora_package] Implemented error checking and updated the documentation
- [core] Add support for catching additional errors
- [ora_package] Use refactered sql routine with raw access
- [ora_package] Initial implementation
- [ora_schema_definition] Implement empty instances method
- [facts] Add generic setup for making your own facts
- [core] set all files modes to correct values
- [core[ Handle -MGMTDB database
- [docs] Added documetation for using non-standard os users

### 13-07-2016 Version 2.2.2
- [core] Add correct geppetto  project file
- [ora_object_grant] Fix autorequire in ora_object_grant
- [core] Add geppetto  project file
- [ora_tablespace] Fix managing properties of temporary tablespaces
- [ora_object_grant] If object name has a user, autorequire it
- [ora_object_grant] Add autorequire to grantee
- [ora_user] Fix error when quota is empty
- [ora_user] Fix error in multiple properties when just one change
- [ora_object_grant] Use a prefetching provider to spare memory

### 29-06-2016 Version 2.2.1
- [ora_user] Fix error when only grants change

### 28-06-2016 Version 2.2.0
- [core] Better checking on db sid
- [core] moved all shared properties to named directory
- [ora_asm_volume] Fix the index operation
- [ora_asm_disk_group] Fix index operation
- [ora_schema_definition] Fix error in creation sql
- [core] Load profile but reset path to wd of parent proces
- [ora_user] Fix when default_roles and grants are specified
- [ora_user] Add properties locked & expired
- [core] Don't load profile for oracle commands
- [core] Better error reporting on all sql
- [ora_synonym] Replace simple provider by prefetching one
- [ora_instance] Initial implementation
- [ora_synonym] First implementation
- [ora_directory] Initial implementation


### 26-05-2016  Version 2.1.0
- [ora_asm_diskgroup] Make sure the disks are in sync
- [ora_init_param] Fix when running in a RAC cluster
- [ora_user] fix default_roles property
- [ora_user] Make profile an uppercase property
- [ora_user] Remove user_id
- [core] Remove temporary files after we have used it.
- [ora_user] Add support for default_roles
- [ora_tablespace] Make size updates work with Oracle Managed Files
- [ora_user] Fix Puppet deprecation warning
- [ora_role] Fix Puppet deprecation warning
- [ora_profile] Fix Puppet deprecation warning
- [ora_object_grant] Fix Puppet deprecation warning
- [ora_init_param] Fix Puppet deprecation warning
- [ora_exec] Fix Puppet deprecation warning
- [ora_tablespace] Fix usage of oracle named files
- [ora_profile] Add new type to manage Oracle user profiles
- [ora_user] Added profile property
- [ora_schema_definition] Fix downgrade paths
- [ora_asm_diskgroup] Remove empty lines in create statement
- [ora_tablespace] Fix typo in help text
- [ora_asm_diskgroup] Use the au_size propery on creating the diskgroup
- [ora_user] Fix issue with default password
- [core] Adhere to puppetlabs guidelines for libraries
- [ora_user] Generate a radnom password for a user when password is not specified
- [core] Update used gems
- [core] Fix security issues with world readable files
- [ora_user] Make password a manageble property
- [ora_object_grants] Change resource name and added default permissions
- [ora_object_grant] Fix possible error on insync?. Closes #72
- [ora_object_permissions] Fix case sensitivity for permissions. Closes #71
- [ORA_RECORD] Updated documentation
- Improved documentation for several types
- [ORA_OBJECT_GRANT] renamed the type ora_object_permission to ora_object_grant
- [ORA_INIT_PARAM] Fix error in idempotence when value is a real number
- Some generic fixes
- Add support for modified_only acceptance tests
- [ORA_USER] Added checks for object_rights
- Removed the check for old sid syntax.
- [ORA_OBJECT_PERMISSION] Added type to  manage object permissions
- [ORA_EXEC] Add support for ignoring SQLPlus errors
- Add better documentation
- Move acceptance tests over to Oracle 12C
- Update travis for Puppet 4.2.3
- Fix test versions
- [ORA_DATABASE] Fix test manifest
- ORA_TABLESPACE] Fix creation of temporary tablespaces
- [ORA_INIT_PARAM] Quote the parameter name
- [ORA_TABLESPACE]Fix autoextending and changing size
- Acceptance tests running in enterprisemodules context
- Add identity files
- Update of the Gems. This allows us to run rake acceptance again
- [ORA_TABLESPACE] Add support fot specifying block_size

### 30-10-2015  version 2.0.0.0
---------------------------
- Renamed to ora_config

### 27-10-2015  version 1.7.22
--------------------------
- Fix when using ora_init_param on multiple instances

### 27-10-2015  version 1.7.21
--------------------------
- Fix when using ora_init_param when one of the instances is a ASM instance

### 26-10-2015  version 1.7.20
--------------------------
- Fix when using ora_init_param on a node with multiple databases
- Fix when using ora_init_param without a specfied database.

### 26-08-2015  version 1.7.19
--------------------------
- timeout parameter was not honoured. Now fixed

### 26-08-2015  version 1.7.18
--------------------------
- Fix undefined method sort for ora_init_param

### 25-08-2015  version 1.7.17
--------------------------
- Fix null quota's for ora_user.
- Fix idempotence for autoextend and maxsize

### 10-08-2015  version 1.7.16
--------------------------
- Added support for multiple values in ota_init_parameter

### 10-08-2015  version 1.7.15
--------------------------
- Allow letters in versionnumber of ora_racord upgrade and downgrade scripts

### 16-07-2015  version 1.7.14
--------------------------
- Set ownership for some more directories when creating a database

### 06-07-2015  version 1.7.13
--------------------------
- refreshonly on ora_exec now only logs a message when something is done.

### 06-07-2015  version 1.7.12
--------------------------
- Fix dropping triggers when reinstalling schema

### 01-07-2015  version 1.7.11
--------------------------
- Use instance name instead of database name for orapwd name.

### 19-06-2015  version 1.7.10
--------------------------
- only use lb_advisory on RAC clusters

### 17-06-2015  version 1.7.9
--------------------------
- added lb_advisory property to ora_service

### 17-06-2015  version 1.7.8
--------------------------
- Added refreshonly for ora_exec
- Check if the cwd specified for ora_exec is valid

### 09-06-2015  version 1.7.7
--------------------------
- Add support for timezone parameter on Ora_database

### 04-06-2015  version 1.7.6
--------------------------
- Small fixes in ora_schema_definition

### 02-06-2015  version 1.7.5
--------------------------
- Better cleanup of schema_definition
### - Translate latest version to real number

### 02-06-2015  version 1.7.4
--------------------------
- Better logging of script that are running
- Ignore characters in versions of upgrade and downgrade scripts


### 27-05-2015  version 1.7.3
--------------------------
- Small fix for ora_schema_defintion removing occasional error's

### 22-05-2015  version 1.7.2
--------------------------
- Better error checking on data attribute of ora_schema_defintion


### 21-05-2015  version 1.7.1
--------------------------
- Small fixes to ora_schema_definition and ora_record.

### 20-05-2015  version 1.7.0
--------------------------
- Added ora_schema_definition type. This type helps in managing the table defintions of your applications
- Added ora_record. This type supports manageing configuration records in database

### 13-05-2015  version 1.6.6
--------------------------
- Fixed creating a tablespace when no datafile is specfied

### 24-04-2015  version 1.6.5
--------------------------
- Fixed changing tablespaces
- Added support for Puppet 4

### 08-04-2015  version 1.6.4
--------------------------
- Now realy works on RAC...

### 04-04-2015  version 1.6.3
--------------------------
- ora_service now works on RAC systems
- ora_service noew presists the services on non RAC systems


### 23-03-2015  version 1.6.2
--------------------------
- Quick bugfix

### 23-03-2015  version 1.6.1
--------------------------
- Small fix for `ora_exec` when `unless` is specfied without a username


### 23-03-2015  version 1.6.0
--------------------------
- Removed the oracle daemon. Totaly. This makes the code easier to read.
- some small changes in `ora_database` for RAC support.
- improved error handling of sql code. This may lead to error's not seen before.
- Support for multiple disks in ora_asm_diskgroups.

### 04-03-2015  version 1.5.4
--------------------------
- Fixed spfile creation on RAC nodes
- Made direct sql the default for sql commands. This is the first step in removing the daemon.

### 07-02-2015  version 1.5.3
--------------------------
- Allow `ora_init_param` to manage ASM instances

### 03-02-2015  version 1.5.2
--------------------------
- Added the `unless` parameter to `ora_exec`

### 30-01-2015  version 1.5.1
--------------------------
- ora_tablespace max_size property now supports value unlimited

### 29-01-2015  version 1.5.0
--------------------------
- Support for asm_volumes
- Added a fact to get asm volume information (With help from Corey Osman)
- Fixed ora_asm_diskgroup attribute au_size


### 19-01-2015  version 1.4.0
--------------------------
- Add grant privileges function to ora_role (Thanks to Edward Groenenberg)
- Now works on Oracle XE (Thanks to Andreas Wegmann)
- ora_database can now remove clustered databases

### 12-01-2015  version 1.3.0
--------------------------
- Re-enginered the ora_database
- make the fact use of os_user work for both Oracle and ASM

### 07-01-2015  version 1.2.0
--------------------------
- Added the initial implementation of ora_database
- Add functionality to use a fact to specify os_user for oracle and asm. Fixes #36


### 07-01-2015  version 1.1.0
--------------------------
- Cleaned up contents of distributed package
- autorequire the oracle users tablespace
- Some fixes and clarifications for ora_asm_diskgroup. BEWARE: The api has changed. Check the README for details.
- Added support for oratab on Solaris.


### 16-12-2014  version 1.0.0
--------------------------
- Fixed some bugs

### 27-11-2014  version 0.7.0
--------------------------
-Big API change. Change all type names to ora_..
- Have the sid at with @ at the back instead with a slach at the front. eg. it used to be SID/HAJEE. Now it is HAJEE@SID


### 27-11-2014  version 0.6.0
--------------------------
- init params now works with a different syntax for specifying the name. Check the readme for details
- Added support for 'growing' small file tablespaces. the type doesn't try to downscale a grown tablespace
- Added support for running under a different os_user.


### 07-10-2014  version 0.5.0
--------------------------
- Added custom type asm_diskgroup. This group supports creating and removing ASM disk groups.
Parts of it are writen by Remy van Berkum (remy.vanberkum@vermont24-7.com). Also added support
for connecting to the ASM instances with the sysasm user


### 24-09-2014  version 0.4.0
--------------------------
- Added some types needed for Oracle RAC


### 08-09-2014  version 0.3.1
--------------------------
- defaults SID's now work for all types.
- Changed documentation to show use with SID

### 08-09-2014  version 0.3.0
--------------------------
- Added support for multiple SID's.
- The listener now needs a sid as title. This is potential incompatible with previous versions where the name could be anything.
- Added support for specifying the SID for init_param

Before this, history not really recorded. Look at git history for details
