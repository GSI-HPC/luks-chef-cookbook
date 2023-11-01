Vagrant.configure(2) do |config|
  # install the Debian-provided Chef package
  config.vm.provision 'shell', inline: <<-SHELL
     sudo apt-get -qq update
     sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install ruby --no-install-recommends
     sudo DEBIAN_FRONTEND=noninteractive apt-get -qq -y install chef --no-install-recommends
     sudo gem install chef-vault --version '< 4'
  SHELL

  # configure proxy if required:
  if Vagrant.has_plugin?('vagrant-proxyconf')
    config.proxy.http     = 'http://proxy.gsi.de:3128/'
    config.proxy.https    = 'http://proxy.gsi.de:3128/'
    config.proxy.no_proxy = 'localhost,127.0.0.1,.gsi.de'
  end
end
