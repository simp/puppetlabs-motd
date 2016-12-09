# Manage /etc/issue and /etc/issue.net
#
# @param content
#   Defaults to a stock `/etc/issue` file in the module. Provide a custom
#   string or file reference to customize. Follows the File content
#   parameter syntax.
# @param net_source
#   The source where `/etc/issue.net` comes from. Defaults to a symlink to `/etc/issue`.
#   Follows the File source parameter syntax.
# @param net_content
#
#
class motd::issue (
  $content       = 'puppet:///modules/motd/issue',
  $link_to_issue = true,
  $net_content   = undef
) {

  $net_source = $link_to_issue ? {
    true    => 'file:///etc/issue',
    default => undef
  }

  if !$link_to_issue and !$net_content {
    fail('If $link_to_issue is false, $net_content needs to be provided.')
  }

  file { '/etc/issue':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => $content
  }
  file { '/etc/issue.net':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => $net_content,
    source  => $net_source,
    require => File['/etc/issue']
  }

}