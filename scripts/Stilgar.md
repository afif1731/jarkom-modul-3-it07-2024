# Script Stilgar (Load Balancer)

- [Init](#init)
- [10-11](#10-11)
- [12](#12)

## Init

- `init-script.sh`
```bash
apt-get update
apt-get install nginx -y

service nginx start

# Round Robin - 3 Workers
echo 'upstream round_robin_3w  {
    server 10.67.1.2; #Vladimir
    server 10.67.1.3; #Rabban
    server 10.67.1.4; #Feyd
}

server {
    listen 8000;

        location / {
            proxy_pass http://round_robin_3w;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }

    error_log /var/log/nginx/loadb_error.log;
    access_log /var/log/nginx/loadb_access.log;
}
' > /etc/nginx/sites-available/round_robbin_3w.conf

# IP Hash - 3 workers
echo 'upstream ip_hash_3w  {
    ip_hash;
    server 10.67.1.2; #Vladimir
    server 10.67.1.3; #Rabban
    server 10.67.1.4; #Feyd
}

server {
    listen 8001;

        location / {
            proxy_pass http://ip_hash_3w;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }

    error_log /var/log/nginx/loadb_error.log;
    access_log /var/log/nginx/loadb_access.log;
}
' > /etc/nginx/sites-available/ip_hash_3w.conf

# Generic Hash - 3 workers
echo 'upstream gen_hash_3w  {
    hash $request_uri consistent;
    server 10.67.1.2; #Vladimir
    server 10.67.1.3; #Rabban
    server 10.67.1.4; #Feyd
}

server {
    listen 8002;

        location / {
            proxy_pass http://gen_hash_3w;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }

    error_log /var/log/nginx/loadb_error.log;
    access_log /var/log/nginx/loadb_access.log;
}
' > /etc/nginx/sites-available/gen_hash_3w.conf

# Least Conn - 3 workers
echo 'upstream least_conn_3w  {
    least_conn;
    server 10.67.1.2; #Vladimir
    server 10.67.1.3; #Rabban
    server 10.67.1.4; #Feyd
}

server {
    listen 8003;

        location / {
            proxy_pass http://least_conn_3w;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }

    error_log /var/log/nginx/loadb_error.log;
    access_log /var/log/nginx/loadb_access.log;
}
' > /etc/nginx/sites-available/least_conn_3w.conf

# Least Conn - 2 workers
echo 'upstream least_conn_2w  {
    least_conn;
    server 10.67.1.2; #Vladimir
    server 10.67.1.3; #Rabban
    #server 10.67.1.4; #Feyd
}

server {
    listen 8004;

        location / {
            proxy_pass http://least_conn_2w;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }

    error_log /var/log/nginx/loadb_error.log;
    access_log /var/log/nginx/loadb_access.log;
}
' > /etc/nginx/sites-available/least_conn_2w.conf

# Least Conn - 1 worker
echo 'upstream least_conn_1w  {
    least_conn;
    server 10.67.1.2; #Vladimir
    #server 10.67.1.3; #Rabban
    #server 10.67.1.4; #Feyd
}

server {
    listen 8005;

        location / {
            proxy_pass http://least_conn_1w;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }

    error_log /var/log/nginx/loadb_error.log;
    access_log /var/log/nginx/loadb_access.log;
}
' > /etc/nginx/sites-available/least_conn_1w.conf

ln -s /etc/nginx/sites-available/round_robbin_3w.conf /etc/nginx/sites-enabled/round_robbin_3w

ln -s /etc/nginx/sites-available/ip_hash_3w.conf /etc/nginx/sites-enabled/ip_hash_3w

ln -s /etc/nginx/sites-available/gen_hash_3w.conf /etc/nginx/sites-enabled/gen_hash_3w

ln -s /etc/nginx/sites-available/least_conn_3w.conf /etc/nginx/sites-enabled/least_conn_3w

ln -s /etc/nginx/sites-available/least_conn_2w.conf /etc/nginx/sites-enabled/least_conn_2w

ln -s /etc/nginx/sites-available/least_conn_1w.conf /etc/nginx/sites-enabled/least_conn_1w

service nginx restart
```

## 10-11

- `1011-script.sh`
```bash
apt-get update
apt-get install apache2-utils -y

mkdir -p /etc/nginx/supersecret

htpasswd -bc /etc/nginx/supersecret/htpasswd secmart kcksit07

# Round Robin - 3 Workers
echo 'upstream round_robin_3w  {
    server 10.67.1.2; #Vladimir
    server 10.67.1.3; #Rabban
    server 10.67.1.4; #Feyd
}

server {
    listen 8000;
        location ~ /dune {
            rewrite ^/dune(.*)$ /$1 break;
            proxy_pass https://www.dunemovie.com.au:443;
            break;
        }

        location / {
            auth_basic "Super Secret - Do Not Pass";
            auth_basic_user_file /etc/nginx/supersecret/htpasswd;
            proxy_pass http://round_robin_3w;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }

    error_log /var/log/nginx/loadb_error.log;
    access_log /var/log/nginx/loadb_access.log;
}
' > /etc/nginx/sites-available/round_robbin_3w.conf

ln -s /etc/nginx/sites-available/round_robbin_3w.conf /etc/nginx/sites-enabled/round_robbin_3w

service nginx restart
```

## 12

- `12-script.sh`
```bash
# Round Robin - 3 Workers
echo 'upstream round_robin_3w  {
    server 10.67.1.2; #Vladimir
    server 10.67.1.3; #Rabban
    server 10.67.1.4; #Feyd
}

server {
    listen 8000;
        location ~ /dune {
            rewrite ^/dune(.*)$ /$1 break;
            proxy_pass https://www.dunemovie.com.au:443;
            break;
        }

        location / {
            allow 10.67.1.37;
            allow 10.67.1.67;
            allow 10.67.2.203;
            allow 10.67.2.207;
            deny all;

            auth_basic "Super Secret - Do Not Pass";
            auth_basic_user_file /etc/nginx/supersecret/htpasswd;
            proxy_pass http://round_robin_3w;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }

    error_log /var/log/nginx/loadb_error.log;
    access_log /var/log/nginx/loadb_access.log;
}
' > /etc/nginx/sites-available/round_robbin_3w.conf

ln -s /etc/nginx/sites-available/round_robbin_3w.conf /etc/nginx/sites-enabled/round_robbin_3w

service nginx restart
```