maintainer       "Stefano Kowalke"
maintainer_email "blueduck@gmx.net"
license          "Apache 2.0"
name             "drupal"
description      "Installs/Configures drupal"
#long_description IO.read(File.join(File.dirname(__FILE__), 'README.rst'))
version          "1.0.0"
recipe           "drupal", "Installs and configures Drupal"
recipe           "drupal::cron", "Sets up the default drupal cron"
recipe           "drupal::drush", "Installs drush - a command line shell and scripting interface for Drupal"

%w{ php apache2 mysql openssl firewall cron nginx database apt build-essential curl php-fpm ubuntu}.each do |cb|
  depends cb
end

%w{ ubuntu }.each do |os|
  supports os
end

