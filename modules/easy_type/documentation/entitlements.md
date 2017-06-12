---
layout: documentation
title: Entitlements
keywords: entitlements license
sidebar: easy_type_sidebar
toc: false
---

Enterprise Modules uses an entitlements manager to check what subscriptions you have on what nodes. When you buy an entitlement, Enterprise Modules sends you an entitlements file. These files must be put on the Puppet master and be distributed to all agents.

To make this an easy process, we have created some helper classes to assist you.

## Where to put the entitlement files

The best way to distribute the entitlements files to all nodes, is to create a module called `em_license`, create a directory `files` in it and put all of your entitlements files in there.

Lets say for example that you have a default Puppet installation and are running in a production environment. The path for all the entitlements files would be: `/etc/puppetlabs/code/production/modules/em_license`

## How to enable license

Copying the entitlement files to all agents is one of the first things that has to be done. We have created a helper class to do this for you. In your `site.pp` file, add the lines:

```puppet
include easy_type::license::activate  # Required to distribute EM entitlement files
```

Now every agent in your environment will activate all entitlements in `/etc/puppetlabs/code/production/modules/em_license`.

## Adding a new entitlement

Adding e new entitlement is as simple as just putting the new file in the `/etc/puppetlabs/code/production/modules/em_license` directory. The `easy_type::license::activate`  will take care of the distribution.

## Customizing

By default the `easy_type::license::activate` class will copy all files from the main puppet server. If you want to use a specific server, you can set a value for hiera variable `easy_type::license::available::server`.

If you want another directory and module name, both on the server and on the agent, you can use variable `easy_type::license::available::path`.

Here is an example of setting the properties to a different value:

```yaml
easy_type::license::available::server: large_server
easy_type::license::available::path: my_own_license_module
```

Please use the customizations with care.
