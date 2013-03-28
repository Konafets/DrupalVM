name "drupal"
description "Install Drupal 7 on this VM"

run_list(
  "recipe[drupal]",
  "role[ubuntu]"
)
override_attributes({
  "drupal" => {
    "dir" => "/var/www/labor-drupal",
    "version" => "7.21",
    "db" => {
      "database" => "labor-drupal",
      "user" => "labor-drupal"
    },
    "site" => {
      "name" => "CMS Labor 2013 - Drupal"
    },
    "webserver" => "apache2",
    "database_engine" => "mysql"
  },
  "mysql" => {
    "bind_address" => "127.0.0.1",
    "server_root_password" => "mysql#2013",
    "server_debian_password" => "mysql#2013",
    "server_repl_password" => "mysql#2013"
  }  
})