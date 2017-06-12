# Class: easy_type::license::activate
#
# This class makes sure the EM licenses are activated at the right point during a Puppet run. Best thing is
# add this class in your site.pp. Because it makes sure the entitlements files are copied in the setup stage,
# the entitlements are available when the EM modules start their work.
#
class easy_type::license::activate
{
  require 'stdlib'

  class{'::easy_type::license::available':
    stage => 'setup',
  }
}
