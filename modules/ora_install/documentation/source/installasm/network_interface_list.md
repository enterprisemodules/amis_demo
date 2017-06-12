The list of interfaces to use for RAC.

The value should be a comma separated strings where each string is as shown below

```
InterfaceName:SubnetAddress:InterfaceType
```

where InterfaceType can be either "1", "2", or "3" (1 indicates public, 2 indicates private, and 3 indicates the interface is not used)

An example on how to use this:

```puppet
installasm{'asm12':
  ...
  network_interface_list => 'eth0:140.87.24.0:1,eth1:10.2.1.0:2,eth2:140.87.52.0:3'
  ...
}
```
