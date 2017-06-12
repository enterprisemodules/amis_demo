---
layout: documentation
title: Installation
keywords: installation
sidebar: em_utils_sidebar
toc: false
---
To install this modules, you can use a `Puppetfile`

```
forge "http://forge.enterprisemodules.com"

mod 'enterprisemodules/em_utils'               ,'1.0.x'
```
Then use the `librarian-puppet` or `r10K` to install the software.

You can also install the software using the `puppet module`  command:

```
puppet module install
    --module_repository=http://forge.enterprisemodules.com 
    enterprisemodules-em_utils
```
