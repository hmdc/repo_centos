# Optional parameters in setting up CentOS Yum repository
class repo_centos::params {

  if $::operatingsystemmajrelease {
    $releasever = $::operatingsystemmajrelease
  } elsif $::os_maj_version {
    $releasever = $::os_maj_version
  } else {
    $releasever = inline_template('<%= @operatingsystemrelease.split(".").first %>')
  }

  $enable_mirrorlist           = true
  $repourl                     = 'http://mirror.centos.org/centos'
  $debug_repourl               = 'http://debuginfo.centos.org'
  $source_repourl              = 'http://vault.centos.org/centos'
  $mirrorlisturl               = 'http://mirrorlist.centos.org'
  $enable_base                 = true
  $enable_contrib              = false
  $enable_cr                   = false
  $enable_extras               = true
  $enable_plus                 = false
  $enable_scl                  = false
  $enable_updates              = true
  $enable_fasttrack            = false
  $enable_source               = false
  $enable_debug                = false
  $ostype                      = 'CentOS'
  $ensure_base                 = 'present'
  $ensure_cr                   = 'present'
  $ensure_extras               = 'present'
  $ensure_plus                 = 'present'
  $ensure_updates              = 'present'
  $ensure_fasttrack            = 'present'
  $ensure_source               = 'present'
  $ensure_debug                = 'present'

  case $releasever {
    '7': {
      $ensure_contrib          = 'absent'
      $ensure_scl              = 'absent'
      $mirrorlist_tail         = '&infra=$infra'
    }
    '6': {
      $ensure_contrib          = 'present'
      $ensure_scl              = 'present'
      $mirrorlist_tail         = '&infra=$infra'
    }
    '5': {
      $ensure_contrib          = 'present'
      $ensure_scl              = 'absent'
      $mirrorlist_tail         = ''
    }
    default: { }
  }

  $priority_base               = undef
  $priority_contrib            = undef
  $priority_cr                 = undef
  $priority_extras             = undef
  $priority_plus               = undef
  $priority_scl                = undef
  $priority_updates            = undef
  $priority_debug              = undef
  $exclude_base                = undef
  $exclude_contrib             = undef
  $exclude_cr                  = undef
  $exclude_extras              = undef
  $exclude_plus                = undef
  $exclude_scl                 = undef
  $exclude_updates             = undef
  $exclude_debug               = undef

}
