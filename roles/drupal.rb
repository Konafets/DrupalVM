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
      "driver" => "mysql",
      "database" => "labor-drupal",
      "user" => "labor-drupal",
      "password" => "mysql#2013"
    },
    "site" => {
      "admin" => "labor-drupal"
      "name" => "CMS Labor 2013 - Drupal"
    },
    "webserver" => "nginx"
  },
  "mysql" => {
    "server_root_password" => "mysql#2013",
    "server_debian_password" => "mysql#2013",
    "server_repl_password" => "mysql#2013"
  },
  "nginx" => {
    "default_site_enabled" => false
  }
})