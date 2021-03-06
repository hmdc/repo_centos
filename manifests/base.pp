# Base includes the CentOS base files from the initial release
class repo_centos::base {

  include ::repo_centos

  if $repo_centos::enable_base {
    $enabled = '1'
  } else {
    $enabled = '0'
  }
  if $repo_centos::enable_mirrorlist {
    $mirrorlist = "${repo_centos::mirrorlisturl}/?release=\$releasever&arch=\$basearch&repo=os${repo_centos::mirrorlist_tail}"
    $baseurl = 'absent'
  } else {
    $mirrorlist = 'absent'
    $baseurl = $repo_centos::repourl ? {
      Array  => rstrip(join(
        $repo_centos::repourl.map |$url| {
          "${url}/\$releasever/os/\$basearch/"
        },
        ' ',
      )),
      String => "${repo_centos::repourl}/\$releasever/os/\$basearch/"
    }
  }

  # Yumrepo ensure only in Puppet >= 3.5.0
  if versioncmp($::puppetversion, '3.5.0') >= 0 {
    Yumrepo <| title == 'centos-base' |> { ensure => $repo_centos::ensure_base }
  }

  yumrepo { 'centos-base':
    baseurl    => $baseurl,
    mirrorlist => $mirrorlist,
    descr      => 'CentOS-$releasever - Base',
    enabled    => $enabled,
    gpgcheck   => '1',
    gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${::repo_centos::releasever}",
    priority   => $repo_centos::priority_base,
    exclude    => $repo_centos::exclude_base,
  }

}
