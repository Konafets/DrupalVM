#
# Author:: Stefano Kowalke <blueduck@gmx.net>
# Cookbook Name:: drupal
# Recipe:: default
#
# Copyright 2013, Stefano Kowalke
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Set up common php 
include_recipe %w{php php::module_gd php::module_curl php::module_apc}

include_recipe "drupal::drush"

user 'vagrant' do
  gid "www-data"
  shell "/bin/zsh"
  action :modify
end

# Centos does not include the php-dom extension in it's minimal php install.
case node['platform_family']
when 'rhel', 'fedora'
  package 'php-dom' do
    action :install
  end
end

# Setting up a webserver
if node['drupal']['webserver'] == "apache2"
  include_recipe %w{apache2 apache2::mod_php5 apache2::mod_rewrite apache2::mod_expires}
elsif node['drupal']['webserver'] == "nginx"
  include_recipe %w{nginx php-fpm}
else
  log("Only webservers currently supported: apache2 and nginx. You have: #{node[:drupal][:webserver]}") { level :warn }
end

# Setting up a database engine
if node['drupal']['database_engine'] == 'mysql'
  include_recipe %w{php::module_mysql database::mysql}
  
  if node['drupal']['site']['host'] == "localhost"
    include_recipe "mysql::server"
  else
    include_recipe "mysql::client"
  end
elsif node['drupal']['database_engine'] == 'postgres'
  include_recipe %w{php::module_pgsql database::postgresql}
else
  log("Only databases currently supported: mysql and postgres. You have: #{node['drupal']['database_engine']}") {level :warn}
end


# Create database
connection_info = {:host => node['drupal']['db']['host'], :username => 'root', :password => node['mysql']['server_root_password']}

mysql_database node['drupal']['db']['database'] do
  connection connection_info
  action :create
  not_if "mysql -h #{node['drupal']['db']['host']} -u root -p#{node['mysql']['server_root_password']} --silent --skip-column-names --execute=\"SHOW DATABASES LIKE '#{node['drupal']['db']['database']}';\""
end

# Create user and grant all rights
mysql_database_user node['drupal']['db']['user'] do
  connection connection_info
  password node['mysql']['server_root_password']
  database_name node['drupal']['db']['database']
  host node['drupal']['db']['host']
  privileges [:all]
  action :grant
end

mysql_database_user node['drupal']['db']['user'] do
  connection connection_info
  password node['mysql']['server_root_password']
  database_name node['drupal']['db']['database']
  host '%'
  privileges [:all]
  action :grant
end

mysql_database node['drupal']['db']['database'] do
  connection connection_info
  sql "flush privileges"
  action :query
end

# Install Drupal
execute "download-and-install-drupal" do
  cwd  File.dirname(node['drupal']['dir'])
  command "#{node['drupal']['drush']['dir']}/drush -y dl drupal-#{node['drupal']['version']} --destination=#{File.dirname(node['drupal']['dir'])} --drupal-project-rename=#{File.basename(node['drupal']['dir'])} && \
  #{node['drupal']['drush']['dir']}/drush -y site-install -r #{node['drupal']['dir']} --account-name=#{node['drupal']['db']['user']} --account-pass=#{node['mysql']['server_root_password']} --site-name=\"#{node['drupal']['site']['name']}\" \
  --db-url=mysql://#{node['drupal']['db']['user']}:'#{node['mysql']['server_root_password']}'@#{node['drupal']['db']['host']}/#{node['drupal']['db']['database']}"
  not_if "#{node['drupal']['drush']['dir']}/drush -r #{node['drupal']['dir']} status | grep #{node['drupal']['version']}"
end

if node.has_key?("ec2")
  server_fqdn = node['ec2']['public_hostname']
else
  server_fqdn = node['fqdn']
end

directory "#{node['drupal']['dir']}/sites/default/files" do
  mode "0777"
  action :create
end

template "#{node['drupal']['dir']}/sites/default/settings.php" do
  path "#{node['drupal']['dir']}/sites/default/settings.php"
  source "settings.php.erb"
  owner "www-data"
  group "www-data"
  mode "0775"
  variables(
    :user     => node['drupal']['db']['user'],
    :password => node['mysql']['server_root_password'],
    :database => node['drupal']['db']['database'],
    :host => node['drupal']['site']['host']
  )
  not_if {File.exists?("#{node['drupal']['dir']}/sites/default/settings.php")}
end


include_recipe "drupal::cron"

if node['drupal']['webserver'] == "apache2"
  web_app "drupal" do
    template "drupal.conf.erb"
    docroot node['drupal']['dir']
    server_name server_fqdn
    server_aliases node['fqdn']
  end

  execute "disable-default-site" do
    command "sudo a2dissite default"
    notifies :reload, "service[apache2]", :delayed
    only_if do File.exists? "#{node['apache']['dir']}/sites-enabled/default" end
  end
elsif node['drupal']['webserver'] == "nginx"
  template "#{node['nginx']['dir']}/sites-enabled/drupal" do
    source "sites.conf.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(
      :docroot => "#{node['drupal']['dir']}",
      :server_name => server_fqdn
    )
  end
  
  nginx_site "drupal" do
    :enable
  end
end

if node['drupal']['modules']['enable']
  node['drupal']['modules']['enable'].each do |m|
    if m.is_a?Array
      drupal_module m.first do
        version m.last
        dir node['drupal']['dir']
        action :install
      end
    else
      drupal_module m do
        dir node['drupal']['dir']
        action :install
      end
    end
  end
end

if node['drupal']['modules']['disable']
  node['drupal']['modules']['disable'].each do |m|
    if m.is_a?Array
      drupal_module m.first do
        dir node['drupal']['dir']
        action :disable
      end
    else
      drupal_module m do
        dir node['drupal']['dir']
        action :disable
      end
    end
  end
end

if node['drupal']['language']['add']
  node['drupal']['language']['add'].each do |m|
    if m.is_a?Array
      drupal_language m.first do
        dir node['drupal']['dir']
        action :add
      end
    else
      drupal_language m do
        dir node['drupal']['dir']
        action :add
      end
    end
  end
end

if node['drupal']['language']['enable']
  node['drupal']['language']['enable'].each do |m|
    if m.is_a?Array
      drupal_language m.first do
        dir node['drupal']['dir']
        action :enable
      end
    else
      drupal_language m do
        dir node['drupal']['dir']
        action :enable
      end
    end
  end
end

if node['drupal']['language']['disable']
  node['drupal']['language']['disable'].each do |m|
    if m.is_a?Array
      drupal_language m.first do
        dir node['drupal']['dir']
        action :disable
      end
    else
      drupal_language m do
        dir node['drupal']['dir']
        action :disable
      end
    end
  end
end

if node['drupal']['language']['default']
  node['drupal']['language']['default'].each do |m|
    if m.is_a?Array
      drupal_language m.first do
        dir node['drupal']['dir']
        action :setdefault
      end
    else
      drupal_language m do
        dir node['drupal']['dir']
        action :setdefault
      end
    end
  end
end

if node['drupal']['language']['import']
  node['drupal']['language']['import'].each do |m|
    if m.is_a?Array
      drupal_language m.first do
        dir node['drupal']['dir']
        action :import
      end
    else
      drupal_language m do
        dir node['drupal']['dir']
        action :import
      end
    end
  end
end
