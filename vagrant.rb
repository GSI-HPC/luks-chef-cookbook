Vagrant.configure(2) do |config|
  # install the Debian-provided Chef package
  config.vm.provision 'shell', inline: <<-SHELL
     sudo apt-get -qq update
     sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install ruby --no-install-recommends
     sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install chef --no-install-recommends
     sudo gem install chef-vault --version '< 4'
     sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install cryptsetup --no-install-recommends
     fallocate -l 100M /tmp/cryptokitchen.loop
     echo dummbabbler | sudo cryptsetup -q luksFormat /tmp/cryptokitchen.loop
     echo dummbabbler | sudo cryptsetup -q open /tmp/cryptokitchen.loop cryptokitchen
     sudo mkfs.ext4 /dev/mapper/cryptokitchen
     sudo mount /dev/mapper/cryptokitchen /mnt
  SHELL

  # configure proxy if required:
  if Vagrant.has_plugin?('vagrant-proxyconf')
    config.proxy.http     = 'http://proxy.gsi.de:3128/'
    config.proxy.https    = 'http://proxy.gsi.de:3128/'
    config.proxy.no_proxy = 'localhost,127.0.0.1,.gsi.de'
  end
end
