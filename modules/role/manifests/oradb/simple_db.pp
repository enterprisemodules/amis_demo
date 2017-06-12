# Docs
class role::oradb::simple_db()
{
  contain profile::base
  contain profile::oradb::os
  contain profile::oradb::software
  contain profile::oradb::database::db01

  Class['profile::base::hosts']
  -> Class['profile::oradb::os']
  -> Class['profile::oradb::software']
  -> Class['profile::oradb::database::db01']
}
