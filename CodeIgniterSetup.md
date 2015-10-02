  * unpack CodeIgniter
```
mkdir -p /var/www/html/trader-DSS
mv CodeIgniter/system/application /var/www/html/trader-DSS
mkdir /var/www/CodeIgniter
mv CodeIgniter/system /var/www/CodeIgniter/
mv CodeIgniter/* /var/www/html
```

  * setup the index.php file
```
vim /var/www/html/index.php
$system_folder = "/var/www/CodeIgniter/system";
$application_folder = "/var/www/html/trader-DSS";
```

  * setup the .htaccess file by pulling .htaccess file from http://codeigniter.com/wiki/mod_rewrite into /var/www/html/.htaccess

  * setup CodeIgniter config
```
vim /var/www/html/trader-DSS/config/config.php
$config['base_url'] = 'http' . ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') ? 's' : '')
                             .'://'.$_SERVER['HTTP_HOST'] . str_replace('//','/',dirname($_SERVER['SCRIPT_NAME']).'/');
$config['index_page']        = "";
$config['sess_expiration']   = 0;
$config['sess_use_database'] = TRUE;
$config['css']               = 'trader.css';
$config['global_xss_filtering'] = TRUE;
```

  * Check with http://hostname.site.org/welcome

  * setup code igniter's database access
```
vim /var/www/html/trader-DSS/config/database.php 
$db['default']['hostname'] = "10.0.0.3";
$db['default']['username'] = "postgres";
$db['default']['password'] = "happy";
$db['default']['database'] = "trader";
$db['default']['dbdriver'] = "postgre";
$db['default']['dbprefix'] = "";
$db['default']['pconnect'] = TRUE;
$db['default']['db_debug'] = TRUE;
$db['default']['cache_on'] = FALSE;
$db['default']['cachedir'] = "";
$db['default']['char_set'] = "utf8";
$db['default']['dbcollat'] = "utf8_general_ci";
```
  * Start to use the trader code
```
vim /var/www/html/trader-DSS/config/routes.php
$route['default_controller'] = "trader";
$route['scaffolding_trigger'] = "";
```