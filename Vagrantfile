Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "carbonapi-dev"
  config.vm.synced_folder ".", "/home/go/src/github.com/go-graphite/carbonapi"

  config.vm.define "carbonapi" do |carbonapi|
  end

  config.vm.provider :virtualbox do |vb|
    vb.name = "carbonapi"
    vb.customize [
      "modifyvm", :id,
      "--cpuexecutioncap", "100",
    ]
    vb.cpus = 4
    vb.memory = 1024
  end

  config.vm.provision "shell", inline: <<-SHELL
        sudo add-apt-repository -y ppa:longsleep/golang-backports
        sudo apt-get update
        sudo apt-get install -y make golang-go mercurial libcairo2-dev ruby-dev build-essential
        sudo gem install fpm
        export GOPATH=/home/go
        export PATH=$PATH:/home/go/bin/
        cd /home/go/src/github.com/go-graphite/carbonapi
        bash -x contrib/fpm/create_package_deb.sh
  SHELL
end
