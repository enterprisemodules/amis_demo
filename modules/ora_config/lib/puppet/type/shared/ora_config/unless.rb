
newparam(:unless) do
  desc <<-EOD
    A query to determine if the ora_exec must execute or not.

    If the query returns something, either one or more rows, the ora_exec
    is **NOT** executed. If the query returns no rows, the specified ora_exec
    statement **IS** executed.

    The unless clause **must** be a valid query. An error in the query will result in
    a failure of the apply statement.

    If you have specified a username and a password, the unless statement will be
    executed in that context. E.g. logged in as the specfied user with the specfied
    password.

    The default value is empty. Meaning no unless statement is executed and the statement or script
    specified in the title, will always be executed.

        ora_exec{ "create synonym ${user}.${synonym} for PRES.${synonym}":
          unless  => "select * from all_synonyms where owner=\'${user}\' and synonym_name=\'${synonym}\'",
        }

  EOD
end
