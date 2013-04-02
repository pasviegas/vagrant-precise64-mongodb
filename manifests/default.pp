class mongodb {
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  exec {
    'apt-key':
      command => 'apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10';
    '10gen-dist':
      command => "echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' >> /etc/apt/sources.list",
      require => Exec['apt-key'];
    'apt-update':
      command => "apt-get update",
      require => Exec['10gen-dist']
  }

  package { 'mongodb-10gen':
    ensure => present,
    require => Exec['apt-update']
  }

  service { 'mongodb':
    enable => true,
    ensure => running,
    require => Package['mongodb-10gen']
  }

  file { 'mongodb.conf':
    path    => '/etc/mongodb.conf',
    content => template("mongodb/mongodb.conf.erb"),
    notify  => Service['mongodb']
  }
}

include mongodb