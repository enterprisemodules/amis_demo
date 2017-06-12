State to obtain.

The ensure attribute can be one of two values:

- present
- absent

When you specify `present`, Puppet will make sure the resource is available with all specified options and properties.

When the resource is already available(installed), and all attributes are as the are specified, Puppet will do nothing.

When you specify `absent`, Puppet will remove the resource if it is available. If it is not installed, Puppet will do nothing.
