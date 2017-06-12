require "#{File.dirname(__FILE__)}/../puppet_x/enterprisemodules/oracle/define_fact"

#
# For now ora_define_fact only supports Oracle12 facts. When running Oracle 11 all
# these facts will be skipped.
#
ora_define_fact('is_container_db') { "select case when cdb='YES' then 'TRUE' else 'FALSE' end as name  from v$database" }
ora_define_fact('is_root_db')      { "select case when sys_context('userenv', 'con_id') =1 then 'TRUE' else 'FALSE' end as name from dual" }
ora_define_fact('is_seed_db')      { "select case when sys_context('userenv', 'con_id') =2 then 'TRUE' else 'FALSE' end as name from dual" }
ora_define_fact('is_pluggable_db') { "select case when sys_context('userenv', 'con_id') >2 then 'TRUE' else 'FALSE' end as name from dual" }
