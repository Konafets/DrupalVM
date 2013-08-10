============
DrupalVM
============

***********
Description
***********

Installs and configures a virtual machine with `Vagrant <http://www.vagrantup.com/>`_ and also installs and configure a Drupal; it creates the Drupal db user, db password and the database; Furthermore you are able to manage modules and languages.

I created this repository while a CMS lecture at the `Flensburg University of Applied Sciences <fh-flensburg.de>`_. Since we using Drupal only this installs Drupal only ;-).

The default values (modules, languages, servername, username, passwords) were taken from the instruction papers. Feel free to change it, if you are not bound on them.


************
Requirements
************

The follow programs must be installed on you computer:

- Ruby
- Berkshelf
- Virtualbox
- Vagrant

************
Installation
************

This instructions where tested under OSX. I assume that they also working for Linux but I am not sure if they doing the same for Windows too. I wrote also the windows stuff down. 

Please send me hints if you have some improvements or encounter any problems.

1. Install XCode
    Go to https://developer.apple.com/xcode/ and follow the instruction there
  
2. Install the Command Line Tools for XCode
    Go to http://stackoverflow.com/questions/9329243/xcode-4-4-command-line-tools and follow the instructions
    
3. Install MacPorts
   http://www.macports.org/install.php
   
4. Installing Ruby
    If you know that Ruby is installed on your system to to the next topic.
    If you don't know if and which version is installed, type::

        $ ruby -v 

    into your console window. It must be 1.9.2 or above. I am using version 1.9.3
  
    For Mac and Linux users:
         Go to https://rvm.io/ and follow the instructions there.
    
    In short you have to do the following steps::
    
        $ \curl -L https://get.rvm.io | bash -s stable
        $ . ~/.bashrc
        $ . ~/.rvm/scripts/rvm
        $ type rvm | head -n 1
        $ rvm requirements
        $ rvm install 1.9.3
        $ rvm use 1.9.3

    In the first line we download rvm and install it. Second line we reload the bash and in third line we reload rvm. In the fourth line we test if it works. The response from the commandline should be ``rvm is a function``. In the next line we check if there are any dependencies and install them and in the sixth line we download and install version 1.9.3 on the machine. And in the last line we activate this version.
    
    Windows users:
        Go to http://rubyinstaller.org/ and install it from there

5. Install Virtualbox
    Got to https://www.virtualbox.org/wiki/Downloads and pick the right one for your system.

6. Install Vagrant
    Vagrant is a program which sit on top of Virtualbox. It communicates over an API with Virtualbox and you communicate over the commandline with Vagrant.

    At the end you only need one configuration file and a few commands to set up a virtual machine.

    Go to http://www.vagrantup.com/ and download the right version for your system.


7. Installing Berkshelf
    Ruby is the language which can extended with plugins. Rubys plugin manager is called `RubyGem <http://rubygems.org/>`_ or just gem on the commandline. This was installed with Ruby.

    To install berkshelf you have to just type this command into your terminal::

        $ gem install berkshelf

    You also have to install Berkshelf into Vagrant::

        $ vagrant plugin install vagrant-berkshelf

8. Get the DrupalVM configuration files
   If you use `GIT <http://git-scm.com/>`_, get the sources by typing this::

        $ git clone https://github.com/Konafets/DrupalVM.git

   into your terminal. (If not, its a good point to start with ;-))

   If you are in hurry or don't like GIT, you can download a ZIP Achive of the code by clicking on this link https://github.com/Konafets/DrupalVM/archive/master.zip and extract it.

USAGE:
------
On your commandline change into the extracted / cloned folder and type::

	$ vagrant up

into the terminal. If you installed everything correctly its time to lean back, grab a cup of coffee and watch the magic.


Test your Drupal installation:
------------------------------
Open a new tab in your browser and type localhost:8080 into the address bar. It should present you the frontend of your Drupal installation.

Enter ``labor-drupal`` and ``drupaladmin`` as username and password. **I recommend you to change the password.**


ATTRIBUTES:
-----------

If you want to install a different version you just have to customize the version attribute and checksum
(sha256 checksum on the source).
In the drupal role you can override the following attributes

- drupal[:version] - version of drupal to download and install (default: 7.21)
- drupal[:dir] - location to copy the drupal files. (default: /var/www/drupal)
- drupal[:db][:database] - drupal database (default: labor-drupal)
- drupal[:db][:user] - drupal db user (default: labor-drupal)
- drupal[:db][:host] - durpal db host (default: localhost)
- drupal[:db][:password] - drupal db password (drupaladmin)

- default['drupal']['webserver'] - select the webserver. Valid values are "apache2" or "nginx" (default: nginx)

- drupal[:drush][:version] - version of drush to download (default: 3.3)
- drupal[:drush][:checksum] - sha256sum of the drush tarball
- drupal[:drush][:dir] - where to install the drush file. (default: /usr/local/drush)

- drupal[:modules][:enable] - a list of modules to enable. The module will be downloaded if it not found locally. (default: empty)
- drupal[:modules][:disable] - a list of modules to disable (default: empty)

- drupal[:language][:add] - a list of languages to add. Use the langcode to define the language.
- drupal[:language][:default] - set the default language. Use the langcode to define the language.
- drupal[:language][:enable] - a list of languages to enable. Use the langcode to define the language.
- drupal[:language][:disable] = a list of languages to disable. Use the langcode to define the language.
- drupal[:language][:import] = a list of languages to import the .po file. Use the langcode to define the language.

==================
License and Author
==================

:Author: 
	Stefano Kowalke <blueduck@gmx.net>
	
:Copyright:  
	2013, Stefano Kowalke

Copyright (c) 2013, Stefano Kowalke

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
