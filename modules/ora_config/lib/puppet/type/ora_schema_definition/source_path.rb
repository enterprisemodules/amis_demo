require 'easy_type/source_dir'

newparam(:source_path, :parent => EasyType::SourceDir) do
  include EasyType

  desc <<-EOD
    the source containing the sql upgrade and downgrade scripts.

    You can use either:

    a base directory:

        ora_schema-definition{'app':
          ensure => latest,
          source => '/staging'
        }

    or

        ora_schema-definition{'app':
          ensure => latest,
          source => 'file:///staging'
        }

    in this case, puppet will look for upgrade and downgrade scripts in:
      /staging/app/sql/upgrades
      /staging/app/sql/downgrades

    an url:

        ora_schema-definition{'app':
          ensure   => latest,
          temp_dir => '/tmp/app'
          source   => 'http://host/app010.tar.Z'
        }

    In this case, the type will fetch the specfied file from the puppet master, decompress and
    untar it into the `temp_dir`. Then the type will search for the `upgrades` and ` downgrades` directorys
    in the zip and use those.

    The following kind of URL's are supported:

    * `puppet:` URIs, which point to files in modules or Puppet file server
    mount points.
    * Fully qualified paths to locally available files (including files on NFS
    shares or Windows mapped drives).
    * `file:` URIs, which behave the same as local file paths.
    * `http:` URIs, which point to files served by common web servers

    The normal form of a `puppet:` URI is:

    `puppet:///modules/<MODULE NAME>/<FILE PATH>`

    This will fetch a file from a module on the Puppet master (or from a
    local module when using Puppet apply). Given a `modulepath` of
    `/etc/puppetlabs/code/modules`, the example above would resolve to
    `/etc/puppetlabs/code/modules/<MODULE NAME>/files/<FILE PATH>`.

    ## Container file

    When the file is a container file, it will automaticaly be extracted. At this point in
    time the follwoing container types are supported:

    - zip
    - tar

    ## Compressed files

    When the file is compressed, it will be uncompressed before beeing procesed further. This means that for example
    a file `https://www.puppet.com/files/all.tar.gz` will be uncompressed before being unpackes with `tar`

    ## Examples

    Here are some examples:

    ### A puppet url containing a zip file

        ora_schema_definition { '...':
          ...
          source  => 'puppet:///modules/software/software.zip',
          tmp_dir => '/tmp/mysoftware'
          ...
        }

    The `software.zip` file will be fetched from the puppet server software module and put in `/tmp/mysoftware`, it will be unzipped and used for the actions
    in the custom type. The file will be temporary put in


    ### A http url containing a tar file

    ora_schema_definition { '...':
      ...
      source  => 'http:///www.enterprisemodules.com/software/software.tar',
      tmp_dir => '/tmp/mysoftware'
      ...
    }


    The `software.tar` file will be fetched from the named web server and put in `/tmp/mysoftware`, it will be untarred and
    used for the actions in the custom type.

    ### A file url fcontaining a compressed tar file

    ora_schema_definition { '...':
      ...
      source  => 'file:///nfsshare/software/software.tar.Z',
      tmp_dir => '/tmp/mysoftware'
      ...
    }

    The `software.tar.Z` file will be fetched from the namedd irectory, it will be uncompressed and then untarred on and put in `/tmp/mysoftware`
    and used for the actions in the custom type.


  EOD
end
