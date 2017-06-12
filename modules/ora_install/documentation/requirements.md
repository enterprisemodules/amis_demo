---
title: Requirements
layout: documentation
keywords: requirements
sidebar: ora_install_sidebar
toc: false
---

This module depends on the `enterprisemodules-easy_type`  module. You can either install this by hand, by using the `puppet module`  command:

```
puppet module install
    --module_repository=http://forge.enterprisemodules.com 
    enterprisemodules-easy_type
```

Or you can use a `Puppetfile`

```
forge "http://forge.enterprisemodules.com"

mod 'enterprisemodules/easy_type'               ,'2.0.x'
```

Then use the `librarian-puppet` or `r10K` to install the software.

The module meta data of this module has the exact version dependency for this module. 
