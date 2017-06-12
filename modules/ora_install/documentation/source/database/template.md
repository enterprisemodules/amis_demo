Use the specified template to create the database.

You can choose between a set of pre-delivered templates, but also specify your own templates.

## Using a pre-delivered template

`ora_install` delivers a few predefined templates.
- dbtemplate_11GR2
- dbtemplate_12.1
- dbtemplate_12.1_asm

Here is an example on how to use this:

```puppet
ora_install::database{ 'testDb_Create':
  ...
  template                  => 'dbtemplate_12.1',
  ...
}
```

## Using your own template

When you specify a template name not pre-delivered by `ora_install`, the defined type will look in the directory specified by `puppet_download_mnt_point` for your own template.

Here is an example:

```puppet
  template                   => 'my_dbtemplate_11gR2_asm',
  puppet_download_mnt_point  => '/vagrant', # 'ora_install' etc
```

The template must be have the following extension dbt.erb like `dbtemplate_12.1.dbt.erb`

- Click here for an [12.1 db instance template example](https://github.com/enterprisemodules/ora_install/blob/master/templates/dbtemplate_12.1.dbt.erb)
- Click here for an [11.2 db asm instance template example](https://github.com/enterprisemodules/ora_install/blob/master/templates/dbtemplate_11gR2_asm.dbt.erb)
