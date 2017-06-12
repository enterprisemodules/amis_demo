History
========

## 13-03-2017 Version 2.2.5
- [functions] Add url_template function
- [license] Add em_utils classes to easy_type

## 20-02-2017 Version 2.2.4
- [yaml_type] Fix when property contains a symbol value
- [validators] Make FQDN test more strict

## 27-01-2017 Version 2.2.3
- [docs] Fix docs tasks
- [provider] Fix append in combination with skip_without_properties
- [provider] Allow append options to on_… actions
- [source_dir] More specific verbose messages
- [yaml_type] Make ruby 1.9 compatible
- [provider] Add support for multiple providers in identity
- [resource_value] Add generated documentation
- [core] Create a tag for publishing

## 18-01-2017 Version 2.2.2
- [rake] Remove not used rake file
- [type] Better name for prefetch routine
- [entitlements] Added support for validators to all entitlements
- [type] Implemented the on_prefetch method
- [entitlements] Add support for passing the resources list to all validators
- [entitlements} Better readable warning when entitlement almost expired
- [entitlements] Add support for sized entitlements

## 02-01-2017 Version 2.2.1
- [core] Updated used versions
- [type] Better error message when using old map_title_to_attributes
- [resource_value] Start using map_titles_to_attributes

## 30-12-2016 Version 2.2.0
- [type] Add support for map_titles_to_attributes
- [core] Add support for dumping  resource content
- [property_value] Add initial implementation.

## 11-12-2016 Version 2.1.0
- [travis] Fix rake issue in test
- [core] Add support for parameterless on_apply and before_* and after_ methods

## 22-11-2016 Version 2.0.23
- [encryption] Extracted the encryption and decryption functionality
- [yaml_type] Add support for ensurable yaml types
- [yaml_type] Add shortcut to add and remove entries without calling puppet

## 20-11-2016 Version 2.0.22
- [yaml_type] Initial implementation

## 07-11-2016 Version 2.0.21
- [daemon] Show current output on timeout. This produces better errors on timeout

## 31-10-2016 Version 2.0.20
- [daemon] Add support for customizable error strings

## 27-10-2016 Version 2.0.19
- [entitlements] Add emlicense utility
- [entitlements] Fix fetching of  entitlements file

## 26-10-2016 Version 2.0.18
- [entitlement] Better mechanism for getting puppetserver name

## 26-10-2016 Version 2.0.17
- [entitlement] Add support for license ID

## 29-09-2016 Version 2.0.16
- [array_property] Remove change_to_s as module function

## 21-09-2016 Version 2.0.15
- [array_property] Make the change_to_s callable
- [source_dir] Better name for extract dir

## 19-09-2016 Version 2.0.14
- [source_dir] Add Initial implementation
- [rake] Add shared rake tasks for publishing and documentation
- [dcos] Add DocSimulator class for classes and defined types

## 26-08-2016 Version 2.0.13
- [helpers] Fix error in quoting

## 22-08-2016 Version 2.0.12
- [provider] Fix identity check when using subclasses for provides

## 21-08-2016 Version 2.0.11
- [helpers] Add support for downloading content through puppet:///.. urls

## 20-08-2016 Version 2.0.10
- [helpers] Better way of handling quoted values

## 18-08-2016 Version 2.0.9
- [entitlement] Changed licensing messages to debug
- [helpers] Add support for quoted fields in convert_csv_data_to_hash
- [template] reimplementation of local_template function
- [template] Better type directory detection

## 15-08-2016 Version 2.0.8
- [template] Add support for local template files.

## 13-08-2016 Version 2.0.7
- Make mechanism to find entitlemnts more robust
- [provider] Fix issue wich needs write access to module
- [entitlements] Add support for multiple numbered entitlements

## 12-07-2016 Version 2.0.6
- [entitlement] Fix error in VirtualBox entitlement

## 12-07-2016 Version 2.0.5
- [entitlement] Added support for numbered entitlement
- [core] Add geppetto  project file

## 07-07-2016 Version 2.0.4
- [spec] extended the tests to more Puppet versions
- [entitlements] Added support for wildcard node and domain specs.

## 04-07-2016 Version 2.0.3
- Add support for multiple concurrent entitlements

## 26-06-2016 Version 2.0.2
- Allow validators to be called as a function

## 17-05-2016 Version 2.0.1
- Add filter for  daemon

## 26-04-2016 Version 2.0.0
- Small fix in domain entitlement validator
- [docs] Added support for generating docs for new doc site
- [type] Remove deduction of module name. Now we must specify it
- [mungers] Allow support for absent values
- [doc]  Fix load path
- [provider] Fix problem when using command_builder
- [type] Move shared properties to module private directory
- [array_property] Fix change message when is or should is absent
- [syncers] Added case insensitive syncer
- [mungers] Added capitalize mungers
- [array_property] Fix check for string with comma
- Update to 1.06
- Small fix in domain entitlement validator
- Added support for encrypted properties
- Add support for ArrayProperty
- Add support for second parameter on translate_to_resources
- Extracted apply_properties in provider
- Better row line detection when converting CSV strings
- Pass eeror output from daemon in exception
- Fix rake tasks

## 12-01-2016 Version 1.0.5
- Allow integer validator to accept negative numbers

## 14-11-2015 Version 1.0.4
- Fix typo in IPAddress validator

## 10-11-2015 Version 1.0.3
- Add some more validators

## 04-11-2015 Version 1.0.2
- Better analysing when there are problems in the daemon processes

## 04-11-2015 Version 1.0.1
- better information on entitlements usage.

## 29-06-2015 Version 1.0.0
- Rebranded and changed license
- Added entitlements management

## 24-05-2015 version 0.15.3
- Fix Now on_modify action recognised when deciding if a property needs to be modified

## 20-01-2015  version 0.15.2
- Fix some generator problems

## 09-01-2015  version 0.15.1
- Uppercase and lowe case mungers more resilent to input

## 08-01-2015  version 0.15.0
- Added support for different commands in command builder api

## 14-12-2014  version 0.14.0
- Add method autoload_when_present

## 28-10-2014  version 0.13.3
- Small fixes in the generated templates

## 28-10-2014  version 0.13.2
- Small fixes in the generator
- Small fixes in the command_builder

## 07-10-2014  version 0.13.1
- Added support for using -%> in erb templates.
- Moved to metadata.json

## 01-09-2014  version 0.13.0
- Added support for specifying a second option parameter on a command_builder. This is needed to support the Oracle SID's

## 01-09-2014  version 0.13.0
- Added support for specifying a second option parameter on a command_builder. This is needed to support the Oracle SID's

## 11-07-2014  version 0.12.2
- Fixed a bug that caused OrwWls to fail.

## 10-07-2014  version 0.12.1
- Added support for specifying the daemon timeout on the sync.

## 10-07-2014  version 0.12.0
- Added support for using `on_create` and `on_modify` instead of just a `on_apply` in the properties. This allows for more granularity in the code and less if's.

## 09-07-2014  version 0.11.0
- Added support for scaffolding and generating properties and parameters.

## 25-06-2014  version 0.10.1
- Added support for Integer mungers. Also refactored the munger module to make it easy to add mungers based on standard classes.

## 19-06-2014  version 0.10.0
- Added support for timeouts on the daemon. Also added suport for refresh of the custom type

## 13-06-2014  Version 0.9.0
- Added support for mapping the title to different attributes and parameters

## 02-06-2014  Version 0.8.1.
- Added support for defining your own pass and fail strings in the Daemon's sync.

## 24-05-2014  Version 0.8.0.
- Added support for daemon's for slow external utilities to be used on multiple types.

## 19-02-2014
- Started using the CSV parser class for parsing the CSV's.

## 16-02-2014
- Renamed all to easy_type. It fits the purpose better

## 12-01-2014	Version 0.2.0.
- Added support for having multiple before and after commands in the CommandBuilder.Added support for getting the property_hash and the property_flush. Added support for including parameter and property file pass the commandbuilder in the on_apply function

## 30-12-2013  Inital version
- based on extraction of common code from Oracle types for prorail deployment
