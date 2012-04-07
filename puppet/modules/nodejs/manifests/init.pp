class nodejs {

      include depends

      exec { "node-clone":
        require => Package["git"],
        command => "git clone /vagrant/node.git /home/vagrant/node",
        creates => "/home/vagrant/node/README.md",
        path => "/usr/bin:/bin",
        user => "vagrant",
        group => "vagrant",
      }

      file { "noderoot":
        path => "/home/vagrant/noderoot",
        owner => "vagrant",
        group => "vagrant",
      }

      exec { "node-version":
        require => Exec["node-clone"],
        command => "git checkout v0.6.9",
        # unfortunately, we have no creates here; stupid git.
        path => "/usr/bin:/bin",
        cwd => "/home/vagrant/node",
        user => "vagrant",
        group => "vagrant",
      }
      
      exec { "node-install":
        require => [Exec["node-version"], File["noderoot"]],
        command => "sh configure --prefix=/home/vagrant/noderoot ; make ; make install",
        creates => "/home/vagrant/noderoot/bin/node",
        path => "/usr/bin:/bin",
        cwd => "/home/vagrant/node",
        user => "vagrant",
        group => "vagrant",
        timeout => 0,
        logoutput => true,
      }

      exec { "npm-download":
        require => Exec["node-install"],
        command => "curl -o /home/vagrant/npminstall.sh http://npmjs.org/install.sh",
        creates => "/home/vagrant/npminstall.sh",
        path => "/usr/bin:/bin",
        user => "vagrant",
        group => "vagrant",
        timeout => 0, 
        logoutput => true,
      }

      exec { "npm-install":
        require => Exec["npm-download"],
        command => "sh /home/vagrant/npminstall.sh",
        cwd => "/home/vagrant",
        path => "/usr/bin:/bin:/home/vagrant/noderoot/bin",
        user => "vagrant",
        group => "vagrant",
        timeout => 0, 
        logoutput => true,
        environment => ['clean=yes', 'HOME=/home/vagrant']
      }
}