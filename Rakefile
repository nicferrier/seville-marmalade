task :default => 'marmalade_box:up'

namespace :marmalade_box do
  desc "Build the vagrant provisioning environment for Marmalade"

  require 'vagrant'
  
  task :up => [:vagrantup] do
  end

  desc "Clean the provisioning environment"
  task :clean do
    rm_r "node.git"
    rm_r "marmalade.git"
    env = Vagrant::Environment.new
    env.primary_vm.destroy
  end

  desc "Suspend any running VM"
  task :suspend do
    env = Vagrant::Environment.new
    env.primary_vm.suspend if env.primary_vm.state == :running
  end

  task :node_checkout do
    unless Dir.exist?("node.git")
      if Dir.exist?("../node.git")
        sh "git clone ../node.git node.git"
      else
        sh "git clone git://github.com/joyent/node.git node.git"
      end
    end
  end

  task :marmalade_checkout do
    unless Dir.exist?("marmalade.git")
      if Dir.exist?("../marmalade.git")
        sh "git clone ../marmalade.git marmalade.git"
      else
        sh "git clone git@github.com:nicferrier/marmalade.git marmalade.git"
      end
    end
  end

  task :vagrantup => [:node_checkout,
                      :marmalade_checkout, ] do
    desc "Bring up the vagrant VM"
    env = Vagrant::Environment.new
    if env.primary_vm.state != :running
      env.cli("up")
    else
      env.cli("provision")
    end
  end
  
end

# End
