---
layout: documentation
title: Troubleshooting
keywords: open source
sidebar: ora_config_sidebar
toc: false
---
When it fails on a Master-Agent setup you can do the following actions:

- Check the time difference/timezone between all the puppet master and agent machines.
- Update oracle and its dependencies on the puppet master.
- After adding or refreshing the easy_type or oracle modules you need to restart all the PE services on the puppet master (this will flush the PE cache) and always do a puppet agent run on the Puppet master
- To solve this error "no such file to load -- easy_type" you need just to do a puppet run on the puppet master when it is still failing you can move the easy_type module to its primary module location ( /etc/puppetlabs/puppet/module )

When the `ora_database` creation fails:

- First remove all `config_scripts`. Then start again. If the database creation run's fine, check the scripts.
- Check if all the path's in the script exist and log file directories are writable by the specified Oracle user. 
