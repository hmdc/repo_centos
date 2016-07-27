# The CentOS Updates repository
class repo_centos::updates {

  include repo_centos

  if $repo_centos::enable_updates {
    $enabled = '1'
  } else {
    $enabled = '0'
  }
  if $repo_centos::enable_mirrorlist {
    $mirrorlist = "${repo_centos::mirrorlisturl}/?release=\$releasever&arch=\$basearch&repo=updates${repo_centos::mirrorlist_tail}"
    $baseurl = 'absent'
  } else {
    $mirrorlist = 'absent'
    $baseurl = $repo_centos::repourl ? {
      Array  => rstrip(join(
        $repo_centos::repourl.map |$url| {
          "${url}/\$releasever/updates/\$basearch/"
        },
        ' ',
      )),
      String => "${repo_centos::repourl}/\$releasever/updates/\$basearch/"
    }
  }

  # Yumrepo ensure only in Puppet >= 3.5.0
  if versioncmp($::puppetversion, '3.5.0') >= 0 {
    Yumrepo <| title == 'centos-updates' |> { ensure => $repo_centos::ensure_updates }
  }

  yumrepo { 'centos-updates':
    baseurl    => $baseurl,
    mirrorlist => $mirrorlist,
    descr      => 'CentOS-$releasever - Updates',
    enabled    => $enabled,
    gpgcheck   => '1',
    gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${repo_centos::releasever}",
    priority   => $repo_centos::priority_updates,
    exclude    => $repo_centos::priority_exclude,
  }

}
