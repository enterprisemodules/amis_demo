---
layout: documentation
title: Installation
keywords: installation
sidebar: ora_config_sidebar
toc: false
---
To install these modules, you can use a `Puppetfile`

```
forge "http://forge.enterprisemodules.com"

mod 'enterprisemodules/ora_config'               ,'2.3.x'
```
Then use the `librarian-puppet` or `r10K` to install the software.

You can also install the software using the `puppet module`  command:

```
puppet module install
    --module_repository=http://forge.enterprisemodules.com
    enterprisemodules-ora_config
```
