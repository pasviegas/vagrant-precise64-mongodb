class mongodb {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  exec {
    'apt-update':
      command => "apt-get update";
    'apt-key':
      command => 'apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10',
      require => Exec['apt-update'];
    '10gen-dist':
      command => "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' >> /etc/apt/sources.list",
      require => Exec['apt-key']
  }

  package { 'mongodb':
    ensure => installed,
    require => Exec['10gen-dist']
  }

  service { 'mongodb':
    ensure  => running,
    require => Package['mongodb']
  }

  file { 'mongodb.conf':
    path    => '/etc/mongodb.conf',
    content => template("mongodb/mongodb.conf.erb"),
    notify  => Service['mongodb']
  }
}

include mongodb