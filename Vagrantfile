# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
apt-get update
apt-get install -y cmake g++ libjson0-dev libcurl4-gnutls-dev libutfcpp-dev libboost-dev libmosquittopp-dev libmosquitto-dev mosquitto mosquitto-clients build-essential devscripts debhelper git

cd /vagrant
rm -rf build_temp

mkdir build_temp
cd build_temp
git clone --recursive https://github.com/daniel1111/SlackRtm.git

mv SlackRtm/ slackmqtt-0.1
tar -cvvf slackmqtt_0.1.orig.tar slackmqtt-0.1/
gzip slackmqtt_0.1.orig.tar

cp -rv /vagrant/debian/ /vagrant/build_temp/slackmqtt-0.1/

cd /vagrant/build_temp/slackmqtt-0.1/
debuild -us -uc

SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "debian/jessie64"
  config.vm.provision "shell", inline: $script
  config.vm.synced_folder "apt/", "/var/cache/apt"
end
