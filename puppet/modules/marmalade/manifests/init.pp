class marmalade {

      include nodejs
      include depends

      exec { "marmalade-clone":
        require => [Package["git"], Exec["node-version"]],
        command => "git clone /vagrant/marmalade.git /home/vagrant/marmalade",
        creates => "/home/vagrant/marmalade/README.md",
        path => "/usr/bin:/bin",
        user => "vagrant",
        group => "vagrant",
      }

      exec { "marmalade-install":
        require => [Service["mongod"], 
                   Exec["npm-install"], 
                   Exec["marmalade-clone"]],
        command => "/home/vagrant/noderoot/bin/npm install /home/vagrant/marmalade",
        cwd => "/home/vagrant",
        creates => "/home/vagrant/node_modules/marmalade/marmalade.js",
        path => "/usr/bin:/bin:/home/vagrant/noderoot/bin",
        user => "vagrant",
        group => "vagrant",
        environment => "HOME=/home/vagrant",
        timeout => 0, 
        logoutput => true,
      }

      exec { "open-port-3000":
        require => Exec["marmalade-install"],
        command => "iptables -I INPUT 4 -j ACCEPT",
        path => "/sbin",
      }
}
