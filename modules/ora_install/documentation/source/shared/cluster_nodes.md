The names of the nodes in the RAC cluster.

Here is an example on how to use this:

```puppet
installasm{'asm12':
  ...
  cluster_nodes => ['db1', 'db2']
  ...
}
```
