maintainer       "Stefano Kowalke"
maintainer_email "blueduck@gmx.net"
license          "MIT License (MIT)"
name             "DrupalVM"
description      "Installs/Configures drupal"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.rst'))
version          "1.0.0"
#role             "drupal", "Installs and configures Drupal"

%w{ php php-fpm apache2 nginx build-essential mysql git openssl firewall cron database apt curl ubuntu zsh vim}.each do |cb|
  depends cb
end

%w{ ubuntu }.each do |os|
  supports os
end

