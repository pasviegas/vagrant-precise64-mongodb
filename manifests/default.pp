class mongodb {
  package { 'mongodb': ensure => installed }
  service { 'mongodb':
    ensure  => running,
    require => Package['mongodb'],
  }
  file { 'mongodb.conf':
    path    => '/etc/mongodb.conf',
    content => template("mongodb/mongodb.conf.erb"),
    notify  => Service['mongodb'],
  }
}

include mongodb