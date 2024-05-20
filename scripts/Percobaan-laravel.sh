#!/bin/bash

percobaan1() {
    echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3' > /etc/php/8.0/fpm/pool.d/www.conf

    service php8.0-fpm restart
    service nginx restart
}

percobaan2() {
    echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 15
pm.start_servers = 12
pm.min_spare_servers = 3
pm.max_spare_servers = 13' > /etc/php/8.0/fpm/pool.d/www.conf

    service php8.0-fpm restart
    service nginx restart
}

percobaan3() {
    echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 25
pm.start_servers = 22
pm.min_spare_servers = 5
pm.max_spare_servers = 23' > /etc/php/8.0/fpm/pool.d/www.conf

    service php8.0-fpm restart
    service nginx restart
}

echo -e '\n++++++++ Laravel Setup Percobaan ++++++++\n'
echo -e 'Jenis Percobaan\tmax_children\tstart_servers\tmin_spare\tmax_spare'
echo -e 'Percobaan 1\t5\t\t2\t\t1\t\t3'
echo -e 'Percobaan 2\t15\t\t12\t\t3\t\t13'
echo -e 'Percobaan 3\t25\t\t22\t\t5\t\t23'
echo -e '\n'
echo -n 'Masukkan angka Percobaan(1/2/3): '
read optPercobaan

if [ $optPercobaan -eq 1 ];
then
  percobaan1
elif [ $optPercobaan -eq 2 ]; then
  percobaan2
elif [ $optPercobaan -eq 3 ]; then
  percobaan3
else
  echo "Unknown Input"
fi