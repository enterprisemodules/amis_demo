newparam(:refreshonly) do
  desc <<-EOD
    do the exec only when notfied.

    The command should only be run as a
    refresh mechanism for when a dependent object is changed.  It only
    makes sense to use this option when this command depends on some
    other object; it is useful for triggering an action:

    Note that only `subscribe` and `notify` can trigger actions, not `require`,
    so it only makes sense to use `refreshonly` with `subscribe` or `notify`.

        ora_exec {...:
          ...
          refreshonly => true,
        }

    The default value is `false`, meaning the SQL statement is executed as a normal part
    of the Puppet catalog.

  EOD

  newvalues(:true, :false)
end
