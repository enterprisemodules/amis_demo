# Version updates

# 2.1.8
- [database] Add support for Oracle 12.2
- [installdb] export logoutput from exec’s and set default to on_fallure
- [net] Support for 12.2
- [installdb] Add support for Oracle 12.2

# 2.1.7
- [ora_install] Add AGENT_BASE_DIR to template em_agent_pull.properties.erb
- [ora_install] Prevent error at first puppet run
- [autostartdatabase] Add support for multiple databases
- [installasm] Add parameter bash_profile
- [database] Add support for template_type

## 2.1.6
- [goldengate] Add new version to docs
- [db_control] Fix require paths for base class
- [ora_opatch] Add support for puppet generate types

## 2.1.5
- [core] Update meta information
- [installem_agent] Add support for EM agent version 13+. Closes #7
- [goldengate] Make it pre puppet 4 compatible

## 2.1.4
- [goldengate] Add support for version 12.2.1

## 2.1.3
- [core] Source .bashrc in .bash_profile. Closes #6
- [core] Use newer verion of easy_type

## 2.1.2
- [net] Add tmp_dir parameter and logoutput parameter
- [ora_opatch] Add support for http urls, zips and tars
- [ora_opatch] Fix logic for determining oracle and grid user
- [ora_installed_patches] Improved on the mechanism to find grid and oracle owner
- [opatchupgrade] Fix syntax issue for older puppet versions
- [opatchupgrade] Add support for OPatch 12.2.0.1.5 and 11.2.0.3.14
- [ora_opatch] Add support for OPatch 12.2.0.1.5 and 11.2.0.3.14
- [fuctions] Fix function for Puppet4 compatibility
- [installasm] Fixes syntax error in template. Closes #5
- [ora_opatch] Change mode of the provider code

## 2.1.1
- [ora_opatch] Added support for puppet:/// syntac for source
- [installem] Add tmp parameter
- [installdb] Add tmp parameter
- [installasm] Add tmp parameter
- [goldengate] Add tmp parameter
- [client] Add tmp parameter
- [core] Use settings from puppet-lint 2
- [core] Lock used gems
- [core] Add geppetto  project file

## 2.1.0
- [ora_opatch] Fix multiple activation of opatch
- [opatchupgrade] Change default mount dir to new value
- [installasm] Add extra template
- [instalasm] Fix old module name
- [documentation] Included full list of site docs
- [database] Fix quoting of sample_schema property
- [ora_opatch] Fix default directory problem on Solaris
- [ora_opatch] Add comment read only property
- [ora_opatch] Fixed directory management of sources
- [ora_opatch] Autodetect os_user and notify when puppet version to old

## 2.0.5
- [db_control] Fix restart from database when db is down.
- [facts] ora_installed_patches now recognises ASM
- [ora_opatch] When opatch is not installed`, let the fact report an empty set of patches
- [db_control] Fix to adhere to refreshonly

## 2.0.4
- Puppet 4 compatible for db_listener
- Added function to translate ora_opatch resource list to list of physical patches

## 2.0.3
-  Puppet 4 compatible
- added type ora_opatch and facts and functions to manage patches

## 2.0.2
-  Renamed to enterprisemodules/ora_install

## 2.0.1
- bash_profile option for database clients
- rcu 11g fix
- 12.1.0.2 oracle client template
- db_listener type refreshonly fix

## 2.0.0
- All parameters of classes or defines are now in snake case and not in camel case

## 1.0.35
- Add support for Grid 12.1.0.2 (installasm)
- Fix unsetted vars in dbora template
- Added ability to put listener entries in tnsnames.ora

## 1.0.34
- autostart fix so it also works for Oracle Linux 5
- rcu prefix compare check fix ( Uppercase )
- RCU fixes for OIM or OAM 11.1.1.2.3
- installem em_upload_port parameter type fix

## 1.0.33
- Small Suse fix for the autostart service
- new installdb attribute cleanup_installfile
- option to provide the sys username for RCU

## 1.0.32
- be able to provide a listener name for starting the oracle listener ( manifest and custom type)

## 1.0.31
- installasm, stand alone parameter in combination with $grid_type == 'CRS_SWONLY' used as standalone or in RAC
- installasm, .profile fix for ORACLE_SID in case grid_type = HA_CONFIG -> +ASM or in grid_type = CRS_CONFIG -> +ASM1

## 1.0.30
- Removed Oracle Home under base check for ASM installations, in CRS_CONFIG or CRS_SWONLY this is not right

## 1.0.29
- Custom type for oracle db/asm/client/em directory structure instead of using dirtree and some oradb manifests

## 1.0.28
- fixed database install rsp 12.1.0.2
- db_listener custom puppet type/provider, listener.pp calls this type

## 1.0.27
- solaris fix for database.pp and opatch auto
- puppet_download_mnt_point parameter for database.pp which can be used for own db template

## 1.0.26
- Removed create_user functionality in installdb & client, Puppet should do it instead of oradb module
- Support for 12.1 pluggable database
- init_params of database.pp now also support a hash besides a comma separated string
- Refactored dbstructure so it works with multiple oracle homes
- Goldengate 12.1.2 now uses dbstructure

## 1.0.25
- added extra parameter validation to installdb, installasm and installem_agent
- opatch fix for opatch bundle zip files which has subfolders in the zip
- owner of the grid home or oracle home folder fix
- renamed clusterware parameter of the opatch type to opatch_auto
- storage_type parameter is now also used in the dbca command when using a database template
- Added ASM 11.2 Database template

## 1.0.24
- Enterprise Manager agent install with AgentPull & AgentDeploy
- Cleanup install zip files and extracted installation folder in installdb, installasm, installem and client

## 1.0.23
- Enterprise Manager 12.1.0.4 server installation support
- Support for Solaris 11.2
- autostart service for Solaris

## 1.0.22
- db_control puppet resource type, start or stop an instance or subscribe to changes like init_param
- Tnsnames change so it supports a TNS balanced configuration
- changed oraInst.loc permissions to 0755

## 1.0.21
- fix for windows/unix linefeed when oradb is used in combination with vagrant on a windows host
- opatch check bug when run it twice
- Add a tnsnames entry support

## 1.0.20
- Create a Database instance based on a template
- Be able to change the default listener port 1521 in net.pp & database.pp
- Opatch fix to apply same the patch twice on different oracle homes

## 1.0.19
- OPatch support for clusterware (GRID)
- Opatchupgrade now works for grid & database on the same node

## 1.0.18
- Puppet Lint fixes
- Rubocop fixes
- 12.1 Template fix for Oracle RAC

## 1.0.17
- Fix for puppet 3.7 and more strict parsing
- OPatch also checks for OPatch succeeded
- RAC installation parameters for database, installasm, installdb

## 1.0.16
- cleanup readme
- asm/grid for 12.1.0.1 & installasm fix for Oracle Restart fix, 11.2.0.1 rsp template fix

## 1.0.15
- RCU fix for multiple FMW Repositories, installasm fix with zip_extract = false

## 1.0.14
- Rename some internal manifest to avoid a conflict with orawls

## 1.0.13
- Oracle Database & Client 12.1.0.2 Support

## 1.0.11
- database client fix with remote file, set db_snmp_password on a database

## 1.0.10
- oraInst.loc bug fix, option to skip installdb bash profile

## 1.0.9
- 11.2 EE install options

## 1.0.8
- RCU & Opatch fixes in combination with ruby 1.9.3

## 1.0.7
- Added unit tests and OPatch upgrade support without OCM registration

## 1.0.6
- Grid install and ASM support

## 1.0.5
- refactored installdb and support for oinstall groups

## 1.0.4
- db_rcu native type used in rcu.pp

## 1.0.2
- db_opatch native type used in opatch.pp

## 1.0.1
- autostart multiple databases, small fixes

## 1.0.0
- oracle module add##on for user,role and tablespace creation

## 0.9.9
- em_configuration parameter for Database creation

## 0.9.7
- Oracle database 11.2.0.1, 12.1.0.1 client support, refactored installdb,net,goldengate
