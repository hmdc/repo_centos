# CentOS Continuous Release - The continuous release ( CR )
# The continuous release  ( CR ) repository contains rpms from the
# next point release of CentOS, which isnt itself released as yet.
#
# Look at http://wiki.centos.org/AdditionalResources/Repositories/CR
# for more details about how this repository works and what users
# should expect to see included / excluded
class repo_centos::cr {

  include repo_centos

  if $repo_centos::enable_cr {
    $enabled = '1'
  } else {
    $enabled = '0'
  }

  $baseurl = $repo_centos::repourl ? {
    Array  => rstrip(join(
      $repo_centos::repourl,
      '/$releasever/cr/$basearch/'
    )),
    String => "${repo_centos::repourl}/\$releasever/cr/\$basearch/"
  }

  # Yumrepo ensure only in Puppet >= 3.5.0
  if versioncmp($::puppetversion, '3.5.0') >= 0 {
    Yumrepo <| title == 'centos-cr' |> { ensure => $repo_centos::ensure_cr }
  }

  yumrepo { 'centos-cr':
    baseurl  => $baseurl,
    descr    => 'CentOS-$releasever - CR',
    enabled  => $enabled,
    gpgcheck => '1',
    gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${repo_centos::releasever}",
    #priority => '1',
  }

}
