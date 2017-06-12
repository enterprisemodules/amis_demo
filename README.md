# Demo Puppet implementation

This repo contains a demonstration of a simple database installation. It contains no patches and hardly any setup inside of the database (e.g. tablespaces, users, synomyms). It's purpose is to help you guide through an initial installation of an Oracle node with Puppet.
The name of the node indicates which version of Oracle will be installed in it i.e. db112 has version 11.2.

## Starting the nodes masterless

All nodes are available to test with Puppet masterless. To do so, add `ml-` for the name when using vagrant:

```
$ vagrant up <ml-db112|ml-db121|ml-db122>
```
