newparam(:mark_as_error) do
  desc <<-EOD
  Additional error strings or regexes.

  To decide whether an SQL action was successful or not, Puppet
  scan's the output for specific strings indicating an error. Sometimes you want
  full control over what is an error and what is not.

  Using this parameter, you can do just that. When the string or regular expression you specify here, is found, `ora_exec` will signal an error.

    Here is an example:

        ora_exec{'@/tmp/my_script.sql':
          ...
          mark_as_error => /no such user/,
        }

    when your output contains the string `no such user`, an error will
    be raised.

    **WARNING**
    Using this parameter, all normal checks are discarded. So use
    this parameter with care

  EOD
end
