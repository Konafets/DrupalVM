===========
Description
===========

Installs and configures Drupal; it creates the drupal db user, db password and the database;
You will need to manually complete the installation step by visiting http://server_fqdn/install.php

============
Requirements
============

## Platform:

Tested on Ubuntu 12.04. As long as the required cookbooks work (apache, php, mysql) it
should work just fine on any other distributions.

## Cookbooks:

Opscode cookbooks (http://github.com/opscode/cookbooks/tree/master)

* mysql
* php
* apache2
* openssl (used to generate the secure random drupal db password)
* database
* apt
* cron
* curl
* ubuntu
* build-essential
* git 
* php-fpm
* vim
* zsh

# ATTRIBUTES:

* drupal[:version] - version of drupal to download and install (default: 7.21)
* drupal[:checksum] - sha256sum of the source tarball
* drupal[:dir] - location to copy the drupal files. (default: /var/www/drupal)
* drupal[:db][:database] - drupal database (default: drupal)
* drupal[:db][:user] - drupal db user (default: drupal)
* drupal[:db][:host] - durpal db host (default: localhost)
* drupal[:db][:password] - drupal db password (randomly generated if not defined)
* drupal[:src] - where to place the drupal source tarball (default: Chef::Config[:file_cache_path])

* drupal[:drush][:version] - version of drush to download (default: 3.3)
* drupal[:drush][:checksum] - sha256sum of the drush tarball
* drupal[:drush][:dir] - where to install the drush file. (default: /usr/local/drush)

* drupal[:modules][:enable] - a list of modules to enable. The module will be downloaded if it not found locally. (default: empty)
* drupal[:modules][:disable] - a list of modules to disable (default: empty)

* drupal[:language][:add] - a list of languages to add. Use the langcode to define the language.
* drupal[:language][:default] - set the default language. Use the langcode to define the language.
* drupal[:language][:enable] - a list of languages to enable. Use the langcode to define the language.
* drupal[:language][:disable] = a list of languages to disable. Use the langcode to define the language.
* drupal[:language][:import] = a list of languages to import the .po file. Use the langcode to define the language.

# USAGE:

Include the drupal recipe to install drupal on your system; this will enable also the drupal cron:

  include_recipe "drupal"

Include the drush recipe to install drush:

  include_recipe "drupal::drush"

Alternative use the role to install a complete ubuntu linux on your system first. The role also include the recipes drupal, drupal cron and drush:

 run_list(role[drupal])

If you are using Vagrant, add the role into the chef section of the Vagrantfile:

 chef.add_role 	"drupal"


If you want to install a different version you just have to customize the version attribute and checksum
(sha256 checksum on the source)

==================
License and Author
==================

Author:: Marius Ducea (marius@promethost.com)
Author:: Stefano Kowalke <blueduck@gmx.net>
Copyright:: 2010-2012, Promet Solutions, 
Copyright:: 2013, Stefano Kowalke

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=======
Credits
=======

The cookbook is heavily inspired and uses code from the drupal cookbook Marius Ducea (https://github.com/mdxp/drupal-cookbook).
I modified it in the way that it make use of the database cookbook and its able to manage modules (enable, disable) and languages (install, enable, disable, default, import).

With version of the cookbook you can select between an Apache2 or a Nginx webserver. I took the code from this pull request https://github.com/mdxp/drupal-cookbook/pull/1 and make it work.