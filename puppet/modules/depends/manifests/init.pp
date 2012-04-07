class depends {
      $dependancies = ["openssl-devel", "mongodb", "git", "mongodb-server"]

      package { $dependancies:
      }

      service { "mongod":
        ensure => "running",
        require => Package[$dependancies],
      }
}
