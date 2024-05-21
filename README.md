# Laporan Resmi Praktikum Jarkom Modul 3 - Kelompok IT07

| Nama              | NRP        |
| ----------------- | ---------- |
| Muhammad Afif     | 5027221032 |
| Alma Amira Dewani | 5027221054 |

# Pendahuluan

Praktikum modul 2 jarkom terdiri dari 21 soal yang dikerjakan seluruhnya menggunakan `VM GNS3`. Ketentuan tambahannya adalah node debian untuk praktikum ini harus menggunakan docker image `danielcristh0/debian-buster:1.1`.

Berikut merupakan cara penyelesaian modul oleh kelompok IT07.

## No.0 dan 1

Planet Caladan sedang mengalami krisis karena kehabisan spice, klan atreides berencana untuk melakukan eksplorasi ke planet arakis dipimpin oleh duke leto mereka meregister domain name atreides.yyy.com untuk worker Laravel mengarah pada Leto Atreides . Namun ternyata tidak hanya klan atreides yang berusaha melakukan eksplorasi, Klan harkonen sudah mendaftarkan domain name harkonen.yyy.com untuk worker PHP (0) mengarah pada Vladimir Harkonen

Lakukan konfigurasi sesuai dengan peta yang sudah diberikan.

### Buat topologi sesuai soal

![topologis](./img/topologi.png)

### konfigurasi tiap node

- Arakis (Router + DHCP Relay)

```
auto eth0
iface eth0 inet dhcp

# ke Harkonen
auto eth1
iface eth1 inet static
    address 10.67.1.1
    netmask 255.255.255.0

# ke Atreides
auto eth2
iface eth2 inet static
    address 10.67.2.1
    netmask 255.255.255.0

# ke Corrino
auto eth3
iface eth3 inet static
    address 10.67.3.1
    netmask 255.255.255.0

# ke Fremen
auto eth4
iface eth4 inet static
    address 10.67.4.1
    netmask 255.255.255.0
```

- Mohiam (DHCP Server)

```
auto eth0
iface eth0 inet static
    address 10.67.3.2
    netmask 255.255.255.0
    gateway 10.67.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Irulan (DNS Server)

```
auto eth0
iface eth0 inet static
    address 10.67.3.3
    netmask 255.255.255.0
    gateway 10.67.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Dmitri (Client)

```
auto eth0
iface eth0 inet dhcp
```

- Paul (Client)

```
auto eth0
iface eth0 inet dhcp
```

- Chani (Database Server)

```
auto eth0
iface eth0 inet static
    address 10.67.4.2
    netmask 255.255.255.0
    gateway 10.67.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Stilgar (Load Balancer)

```
auto eth0
iface eth0 inet static
    address 10.67.4.3
    netmask 255.255.255.0
    gateway 10.67.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Leto (Laravel Worker)

```
auto eth0
iface eth0 inet static
    address 10.67.2.2
    netmask 255.255.255.0
    gateway 10.67.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Duncan (Laravel Worker)

```
auto eth0
iface eth0 inet static
    address 10.67.2.3
    netmask 255.255.255.0
    gateway 10.67.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Jessica (Laravel Worker)

```
auto eth0
iface eth0 inet static
    address 10.67.2.4
    netmask 255.255.255.0
    gateway 10.67.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Vladimir (PHP Worker)

```
auto eth0
iface eth0 inet static
    address 10.67.1.2
    netmask 255.255.255.0
    gateway 10.67.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Rabban (PHP Worker)

```
auto eth0
iface eth0 inet static
    address 10.67.1.3
    netmask 255.255.255.0
    gateway 10.67.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Feyd (PHP Worker)

```
auto eth0
iface eth0 inet static
    address 10.67.1.4
    netmask 255.255.255.0
    gateway 10.67.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

### Konfigurasi script

Tambahkan baris berikut pada :

- Arakis (Router) - `.bashrc`

```bash
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.67.0.0/16
apt-get update
apt-get install isc-dhcp-relay -y
service isc-dhcp-relay start
```

- Irulan (DNS) - `init-script.sh`

```bash
apt-get update
apt-get install bind9 -y
```

- Mohiam (DHCP) - `init-script.sh`

```bash
apt-get update
apt-get install isc-dhcp-server -y
```

- Client - `init-script.sh`

```bash
apt-get update
apt-get install dnsutils apache2-utils lynx -y
```

### Konfigurasi DHCP Relay

Atur agar DHCP Relay (Arakis) mengarah ke DHCP Server (Mohiam) dan Interface nya terbuka untuk eth1 - eth4

- `/etc/default/isc-dhcp-relay`

```conf
SERVERS="10.67.3.2"
INTERFACES="eth1 eth2 eth3 eth4"
OPTIONS=""
```

### Mendaftarkan domain atreides.it07.com dan harkonen.it07.com

Tambahkan zone `atreides.it07.com` dan `harkonen.it07.com` pada DNS Server (Irulan)

- `/etc/bind/named.conf.local`

```conf
zone "atreides.it07.com" {
	type master;
	file "/etc/bind/jarkom_it07/atreides.it07.com";
};

zone "harkonen.it07.com" {
	type master;
	file "/etc/bind/jarkom_it07/harkonen.it07.com";
};
```

Buat direktori `jarkom_it07` pada path `/etc/bind/`

```bash
mkdir /etc/bind/jarkom_it07
```

Kemudian buat file konfigurasi untuk masing-masing domain dengan ketentuan :

atreides.it07.com mengarah ke Laravel Worker `Leto`

- `/etc/bind/jarkom_it07/atreides.it07.com`

```conf
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     atreides.it07.com. root.atreides.it07.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@             IN      NS      atreides.it07.com.
@             IN      A       10.67.2.2 ; ini IP Leto
```

sementara harkonen.it07.com mengarah ke PHP Worker `Vladimir`

- `/etc/bind/jarkom_it07/harkonen.it07.com`

```conf
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     harkonen.it07.com. root.harkonen.it07.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@             IN      NS      harkonen.it07.com.
@             IN      A       10.67.1.2 ; ini IP Vladimir
```

## No.2

Semua CLIENT harus menggunakan konfigurasi dari DHCP Server.

Client yang melalui House Harkonen mendapatkan range IP dari [prefix IP].1.14 - [prefix IP].1.28 dan [prefix IP].1.49 - [prefix IP].1.70

### Konfigurasi DHCP Server (Mohiam)

Setup Mohiam untuk menerima jaringan IpV4 dari eth0

- `/etc/default/isc-dhcp-server`

```conf
INTERFACES="eth0"
OPTIONS=""
```

Selain itu, atur juga konfigurasi DHCP Server untuk membatasi range IP `Harkonen`. IP memiliki jangkauan dari 10.67.1.14 hingga 10.67.1.28 dan dari 10.67.1.49 hingga 10.67.1.70

- `/etc/dhcp/dhcpd.conf`

```conf
subnet 10.67.3.0 netmask 255.255.255.0 {
    option routers 10.67.3.1;
    option broadcast-address 10.67.3.255;
}

subnet 10.67.4.0 netmask 255.255.255.0 {
    option routers 10.67.4.1;
    option broadcast-address 10.67.4.255;
}

# Konfigurasi untuk subnet Harkonen
subnet 10.67.1.0 netmask 255.255.255.0 {
    range 10.67.1.14 10.67.1.28;
    range 10.67.1.49 10.67.1.70;
    option routers 10.67.1.1;
    option broadcast-address 10.67.1.255;
    option domain-name-servers 192.168.122.1;
}
```

Hapus file dhcpd.pid lalu restart service

- `terminal`

```bash
rm /var/run/dhcpd.pid

service isc-dhcp-server restart
```

## No.3

Client yang melalui House Atreides mendapatkan range IP dari [prefix IP].2.15 - [prefix IP].2.25 dan [prefix IP].2 .200 - [prefix IP].2.210

### Menambahkan Konfigurasi DHCP Server (Mohiam)

Setelah menambahkan subnet untuk Harkonen, tambahkan pula subnet untuk Atreides dengan menambahkan baris baru pada `/etc/dhcp/dhcpd.conf` dengan range 10.67.2.15 hingga 10.67.2.25 dan 10.67.2.200 hingga 10.67.2.210

- `/etc/dhcp/dhcpd.conf`

```conf
# Konfigurasi untuk subnet Atreides
subnet 10.67.2.0 netmask 255.255.255.0 {
    range 10.67.2.15 10.67.2.25;
    range 10.67.2.200 10.67.2.210;
    option routers 10.67.2.1;
    option broadcast-address 10.67.2.255;
    option domain-name-servers 192.168.122.1;
}
```

## No.4

Client mendapatkan DNS dari Princess Irulan dan dapat terhubung dengan internet melalui DNS tersebut

### Mengarahkan domain name server ke arah DNS Server

Pada config DHCP Server, ubah opsi `domain-name-servers` menjadi mengarah ke DNS Server (Irulan)

- `/etc/dhcp/dhcpd.conf`

```conf
# Konfigurasi untuk subnet Harkonen
subnet 10.67.1.0 netmask 255.255.255.0 {
    range 10.67.1.14 10.67.1.28;
    range 10.67.1.49 10.67.1.70;
    option routers 10.67.1.1;
    option broadcast-address 10.67.1.255;
    option domain-name-servers 10.67.3.3;
}

# Konfigurasi untuk subnet Atreides
subnet 10.67.2.0 netmask 255.255.255.0 {
    range 10.67.2.15 10.67.2.25;
    range 10.67.2.200 10.67.2.210;
    option routers 10.67.2.1;
    option broadcast-address 10.67.2.255;
    option domain-name-servers 10.67.3.3;
}
```

### Mengubah opsi pada DNS Server

Opsi bind pada DNS Server juga perlu diubah agar client tetap dapat terhubung ke internet

- `/etc/bind/named.conf.options`

```conf
options {
    listen-on-v6 { none; };
    directory "/var/cache/bind";

    # Forwarders
    forwarders {
        192.168.122.1;
    };

    forward only;

    dnssec-validation no;

    auth-nxdomain no;
    allow-query { any; };
};
```

### Menguji pada client

Jalankan perintah `ifconfig` pada client, nilai inet pada eth0 akan sesuai dengan IP yang sudah kita mapping sebelumnya

Lakukan **ping** pada `atreides.it07.com` dan `harkonen.it07.com`, terkadang responsenya akan datang cukup lama,

namun untuk memastikan bahwa sudah bisa terhubung pada DNS server, lakukan **nslookup** pada `atreides.it07.com` dan `harkonen.it07.com` lalu pastikan bahwa address dari masing masing domain sesuai dengan yang telah dikonfigurasi pada DNS Server.

#### Paul

- ping harkonen.it07.com
  ![paul harkonen](./img/paul-harkonen.png)

- ping atreides.it07.com
  ![paul atreides](./img/paul-atreides.png)

- ping google.com
  ![paul google](./img/paul-google.png)

#### Dmitri

- ping harkonen.it07.com
  ![dmitri harkonen](./img/dmitri-harkonen.png)

- ping atreides.it07.com
  ![dmitri atreides](./img/dmitri-atreides.png)

- ping google.com
  ![dmitri google](./img/dmitri-google.png)

## No.5

Durasi DHCP server meminjamkan alamat IP kepada Client yang melalui House Harkonen selama 5 menit sedangkan pada client yang melalui House Atreides selama 20 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 87 menit

### Mengonfigurasi Leasing Times untuk Subnet Harkonen dan Atreides

Tambahkan lease time pada kedua konfigurasi subnet client dengan ketentuan:

| Client   | Default           | Max               |
| -------- | ----------------- | ----------------- |
| Harkonen | 5 menit (300 s)   | 87 menit (5220 s) |
| Atreides | 20 menit (1200 s) | 87 menit (5220 s) |

- `/etc/dhcp/dhcpd.conf`

```conf
# Konfigurasi untuk subnet Harkonen
subnet 10.67.1.0 netmask 255.255.255.0 {
    range 10.67.1.14 10.67.1.28;
    range 10.67.1.49 10.67.1.70;
    option routers 10.67.1.1;
    option broadcast-address 10.67.1.255;
    option domain-name-servers 10.67.3.3;
    default-lease-time 300;
    max-lease-time 5220;
}

# Konfigurasi untuk subnet Atreides
subnet 10.67.2.0 netmask 255.255.255.0 {
    range 10.67.2.15 10.67.2.25;
    range 10.67.2.200 10.67.2.210;
    option routers 10.67.2.1;
    option broadcast-address 10.67.2.255;
    option domain-name-servers 10.67.3.3;
    default-lease-time 1200;
    max-lease-time 5220;
}
```

## No.6

Vladimir Harkonen memerintahkan setiap worker(harkonen) PHP, untuk melakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3.

### Menginstal keperluan pada PHP Worker

Untuk menjalankan website PHP pada worker, maka keperluan berikut perlu diinstal pada setiap worker PHP (`Vladimir`, `Rabban`, dan `Feyd`)

- `terminal`

```bash
apt-get update
apt-get install nginx wget unzip php7.3 php-fpm -y
```

Nantinya website ini akan dijalankan menggunakan PHP 7.3 dan web server nginx

Website yang dimaksud senndiri terdapat pada [link berikut](https://drive.google.com/file/d/1lmnXJUbyx1JDt2OA5z_1dEowxozfkn30/view).

- `terminal`

```bash
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1lmnXJUbyx1JDt2OA5z_1dEowxozfkn30' -O 'harkonen.zip'
unzip harkonen.zip

# meletakkan komponen web
mkdir -p /var/www/jarkom_it07
mv /root/modul-3/* /var/www/jarkom_it07/

# menghapus hasil download
rmdir /root/modul-3
rm harkonen.zip
```

### Konfigurasi Web Server

Web server yang sudah diinstal dan Komponen web yang sudah didownload perlu dikonfigurasikan agar dapat dijalankan dan diakses oleh client.

Dibuat file konfigurasi baru pada `/etc/nginx/sites-available/` dengan nama `jarkom_it07.conf`

- `/etc/nginx/sites-available/jarkom_it07.conf`

```conf
server {
    listen 80;

    server_name _;

    root /var/www/jarkom_it07;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
    }

    error_log /var/log/nginx/jarkom_it07_error.log;
    access_log /var/log/nginx/jarkom_it07_access.log;
}
```

Restart service nginx lalu periksa hasilnya dengan mengaksesnya melalui client

## No.7

Aturlah agar Stilgar dari fremen dapat dapat bekerja sama dengan maksimal, lalu lakukan testing dengan 5000 request dan 150 request/second.

### Menginstal Keperluan pada Load Balancer

Instal keperluan pada Stilgar (Load Balancer)

- `terminal`

```
apt-get update
apt-get install nginx -y
```

### Konfigurasi Load Balancer

Secara default, load balancer yang digunakan pada nginx adalah load balancer dengan metode `Round Robin`. Konfigurasi dilakukan dengan membuat file konfigurasi baru pada `/etc/nginx/sites-available/`, isinya adalah seperti berikut:

- `/etc/nginx/sites-available/round_robbin_3w.conf`

```conf
upstream round_robin_3w  {
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
```

Aktifkan konfigurasi tersebut lalu restart service nginx

```bash
ln -s /etc/nginx/sites-available/round_robbin_3w.conf /etc/nginx/sites-enabled/round_robbin_3w

service nginx restart
```

Lakukan pengujian menggunakan apache benchmark pada tujuan ip load balancer dengan port 8000

```bash
ab -n 5000 -c 150 http://10.67.4.3:8000/
```

![ab 5000 150](./img/benchmark_5000_150.png)

Hasil yang didapat

![hasil ab](./img/no_7_hasil.png)

## No.8

Karena diminta untuk menuliskan peta tercepat menuju spice, buatlah analisis hasil testing dengan 500 request dan 50 request/second masing-masing algoritma Load Balancer dengan ketentuan sebagai berikut:

- Nama Algoritma Load Balancer
- Report hasil testing pada Apache Benchmark
- Grafik request per second untuk masing masing algoritma.
- Analisis

### Membuka Port Load Balancer

Untuk memudahkan pengujian, maka dibuka beberapa port baru pada load balancer dengan setiap port memiliki metode load balancing yang berbeda

Sehingga Hasil akhirnya akan menajdi seperti berikut

| Port | Method           | Worker(s) |
| ---- | ---------------- | --------- |
| 8000 | Round Robin      | 3 Workers |
| 8001 | IP Hash          | 3 Workers |
| 8002 | Generic Hash     | 3 Workers |
| 8003 | Least Conenction | 3 Workers |

Untuk setiap metode, maka dibuatlah file konfigurasi baru

- `/etc/nginx/sites-available/ip_hash_3w.conf`

```conf
upstream ip_hash_3w  {
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
```

- `/etc/nginx/sites-available/gen_hash_3w.conf`

```conf
upstream gen_hash_3w  {
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
```

- `/etc/nginx/sites-available/least_conn_3w.conf`

```conf
upstream least_conn_3w  {
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
```

### Pengujian menggunakan Script

Dibuat bash script yang dapat memudahkan pengujian, script dapat diakses [di sini](./scripts/LB-test.sh)

Saat script dijalankan, pilih `Multi Test - By LB Method` dan masukkan jumlah request beserta concurrency nya.

![setup](./img/script-setup.png)

Kemudian didapat hasil seperti berikut

![result](./img/script-result.png)

Hasil lengkapnya dapat diakses pada path `/root/report/`

Analisis kemudian dilakukan pada hasil tersebut untuk kemudian dibuat laporan yang dapat diakses melalui [link berikut](https://docs.google.com/document/d/1XDuXZdADYQwS1kBA9vhUOYwM7SZ3cwyaxoOlfSoRVWw/edit?usp=sharing)

## No.9

Dengan menggunakan algoritma Least-Connection, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 1000 request dengan 10 request/second, kemudian tambahkan grafiknya pada peta.

### Membuka Port Load Balancer

Sama seperti sebelumnya, untuk memudahkan pengujian, maka dibuka beberapa port baru pada load balancer dengan setiap port memiliki jumlah worker yang berbeda

Sehingga hasil akhirnya akan menajdi seperti berikut

| Port | Method           | Worker(s) |
| ---- | ---------------- | --------- |
| 8003 | Least Conenction | 3 Workers |
| 8004 | Least Conenction | 2 Workers |
| 8005 | Least Conenction | 1 Workers |

Untuk setiap jumlah, maka dibuatlah file konfigurasi baru. Karena least connection dengan 3 worker telah berjalan, maka hanya perlu menambah dua konfigurasi lagi

- `/etc/nginx/sites-available/least_conn_2w.conf`

```conf
upstream least_conn_2w  {
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
```

- `/etc/nginx/sites-available/least_conn_1w.conf`

```conf
upstream least_conn_1w  {
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
```

### Pengujian menggunakan Script

Dibuat bash script yang dapat memudahkan pengujian, script dapat diakses [di sini](./scripts/LB-test.sh)

Saat script dijalankan, pilih `Multi Test - By LB Method` dan masukkan jumlah request beserta concurrency nya.

![setup](./img/script-setup2.png)

Kemudian didapat hasil seperti berikut

![result](./img/script-result2.png)

Hasil lengkapnya dapat diakses pada path `/root/report/`

Analisis kemudian dilakukan pada hasil tersebut untuk kemudian dibuat laporan yang dapat diakses melalui [link berikut](https://docs.google.com/document/d/1XDuXZdADYQwS1kBA9vhUOYwM7SZ3cwyaxoOlfSoRVWw/edit?usp=sharing)

## No.10

Selanjutnya coba tambahkan keamanan dengan konfigurasi autentikasi di LB dengan dengan kombinasi username: “secmart” dan password: “kcksyyy”, dengan yyy merupakan kode kelompok. Terakhir simpan file “htpasswd” nya di /etc/nginx/supersecret/

### Menambahkan Konfigurasi pada Load Balancer

tambahkan konfigurasi auth_basic untuk mengatur autentikasi pada load balancer

- `/etc/nginx/sites-available/round_robbin_3w.conf`

```conf
location / {
            auth_basic "Super Secret - Do Not Pass";
            auth_basic_user_file /etc/nginx/supersecret/htpasswd;
            proxy_pass http://round_robin_3w;
            proxy_set_header    X-Real-IP $remote_addr;
            proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header    Host $http_host;
        }
```

### Mengatur keperluan autentikasi

Install apache2-utils untuk menggunakan perintah `htpasswd`

```bash
apt-get install apache2-utils
```

Buat credential baru untuk username dan password sesuai dnegan permintaan soal yang kemudian akan disimpan pada file `/etc/nginx/supersecret/htpasswd`

```bash
htpasswd -bc /etc/nginx/supersecret/htpasswd secmart kcksit07
```

lakukan restart pada service nginx kemudian uji pada client

```bash
lynx 10.67.4.3:8000
```

![user auth](./img/auth.png)

## No.11

Lalu buat untuk setiap request yang mengandung /dune akan di proxy passing menuju halaman https://www.dunemovie.com.au/.

### Menambahkan Konfigurasi pada Laod Balancer

Pada konfigurasi load balancer, buat pengaturan tambahan yang akan menghapus path `/dune` kemudian mengarahkannya kepada `https://www.dunemovie.com.au` diikuti dengan path yang mungkin ditambahkan setelah /dune

- `/etc/nginx/sites-available/round_robbin_3w.conf`

```
location ~ /dune {
            rewrite ^/dune(.*)$ /$1 break;
            proxy_pass https://www.dunemovie.com.au:443;
            break;
        }
```

Kemudian lakukan pengujian menggunakan lynx

```bash
lynx 10.67.4.3:8000/dune
```

![tes1](./img/tes1.png)

![tesh1](./img/tesh1.png)

Proxy pass juga dapat meneruskan path yang diletakkan setelah `/dune`

```bash
lynx 10.67.4.3:8000/dune/characters
```

![tes1](./img/tes2.png)

![tesh1](./img/tesh2.png)

## No.12

Selanjutnya LB ini hanya boleh diakses oleh client dengan IP [Prefix IP].1.37, [Prefix IP].1.67, [Prefix IP].2.203, dan [Prefix IP].2.207.

### Menambahkan IP yang diizinkan

Tambahkan semua IP yang diizinkan soal pada config load balancer

- `/etc/nginx/sites-available/round_robbin_3w.conf`

```conf
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
```

Restart Nginx dan uji pada client

```bash
lynx 10.67.4.3:8000
```

![forbidden](./img/forbidden.png)

Client akan mendapatkan error kode `Forbidden` dari load balancer.

### Fix IP untuk Client

Atur Hwaddress pada kedua Client dengan menambahkan config tambahan pada node Paul dan Dmitri

- `Paul`

```conf
auto eth0
iface eth0 inet dhcp
hwaddress ether ea:bd:80:c5:98:e2
```

- `Dmitri`

```
auto eth0
iface eth0 inet dhcp
hwaddress ether 6e:51:8c:8a:93:d8
```

Berikan Fix IP untuk Paul dengan mengatur konfigurasi host Paul

- `/etc/dhcp/dhcpd.conf`

```conf
host Paul {
    hardware ethernet ea:bd:80:c5:98:e2;
    fixed-address 10.67.2.203;
    option host-name "Paul";
}
```

restart isc-dhcp-server kemudian restart juga client Paul bandingkan hasil aksesnya antara Paul dan Dmitri

- `Paul`

```bash
lynx 10.67.4.3:8000
```

![paul 12](./img/paul-12.png)

## No.13

Semua data yang diperlukan, diatur pada Chani dan harus dapat diakses oleh Leto, Duncan, dan Jessica.

### Chani (Database server)

1.  instalasi dependensi

```
apt-get update
apt-get install mariadb-server -y
service mysql start
```

2. lakukan edit di /etc/mysql/my.cnf

```
[client-server]

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
skip-networking=0
skip-bind-address
```

3.  tambahakan bind_adress di /etc/mysql/mariadb.conf.d/50-server.cnf

```
bind-address = 0.0.0.0
```

4. restart my sql

```
service mysql restart
```

5. masuk ke mariadb

```
mysql -u root -p
```

6. jalankan query berikut

```
CREATE USER 'kelompokit07'@'%' IDENTIFIED BY 'passwordit07';
CREATE USER 'kelompokit07'@'localhost' IDENTIFIED BY 'passwordit07';
CREATE DATABASE dbkelompokit07;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit07'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit07'@'localhost';
FLUSH PRIVILEGES;
```

### Leto, Duncan, Jessica (Laravel Worker)

1. install dependensi

```
apt-get update
apt-get install mariadb-client -y
```

2. jalankan command berikut

```
mariadb --host=10.67.4.2 --port=3306 --user=kelompokit07 --password=passwordit07 dbkelompokit07  -e "SHOW DATABASES;"
```

### Hasil Testing

![mariadb leto](./img/13-1.png)

![mariadb duncan](./img/13-2.png)

![mariadb jessica](./img/13-3.png)

## No.14

Leto, Duncan, dan Jessica memiliki atreides Channel sesuai dengan quest guide berikut. Jangan lupa melakukan instalasi PHP8.0 dan Composer

### Leto, Duncan, Jessica (Laravel Worker)

1. install dependensi

```
apt-get update
apt-get install lynx -y
apt-get install wget -y
apt-get install htop -y

apt -y install lsb-release apt-transport-https ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update

apt-get install php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php8.0-intl php8.0-opcache php8.0-readline php8.0-mysql php8.0-fpm php8.0-curl unzip wget -y
apt-get install nginx -y

service nginx start
service php8.0-fpm start
```

2. download file composer, Tambahkan izin eksekusi pada file `composer.phar` dan Pindahkan file `composer.phar` ke `/usr/local/bin/composer`.

```
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/local/bin/composer
```

3. install git, cloning github, update composer dan copy file `.env.example` ke `.env`

```
apt-get install git -y
cd /var/www && git clone https://github.com/martuafernando/laravel-praktikum-jarkom
cd /var/www/laravel-praktikum-jarkom && composer update
cd /var/www/laravel-praktikum-jarkom && cp .env.example .env
```

4. lakukan pengeditan pada `/var/www/laravel-praktikum-jarkom/.env`.

```
#ubah bagian ini saja

DB_HOST=10.67.4.2
DB_PORT=3306
DB_DATABASE=dbkelompokit07
DB_USERNAME=kelompokit07
DB_PASSWORD=passwordit07

```

5. ubah kepimilikan file

```
chown -R www-data.www-data /var/www/laravel-praktikum-jarkom/storage
```

6. buat file di `/etc/nginx/sites-available/jarkom_it07` lalu sesuaikan portnya

```
echo 'server {
    listen 8081; # Leto
    listen 8082; # Duncan
    listen 8083; # Jessica

    root /var/www/laravel-praktikum-jarkom/public;

    index index.php index.html index.htm;
    server_name _;

    location / {
            try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
      include snippets/fastcgi-php.conf;
      fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
    }

    location ~ /\.ht {
            deny all;
    }

    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
}' > /etc/nginx/sites-available/default

```

7. jalankan command berikut

   - unlink file `/etc/nginx/sites-enabled/default`

   ```
   unlink /etc/nginx/sites-enabled/default
   ```

   - buat symlink

   ```
   ln -s /etc/nginx/sites-available/jarkom_it07 /etc/nginx/sites-enabled
   ```

   - start php dan restart nginx

   ```
   service php8.0-fpm start
   service nginx restart
   ```

### Hasil Testing

- lynx localhost:8081
  ![php leto](./img/14-3.png)

- lynx localhost:8082
  ![php duncan](./img/14-1.png)

- lynx localhost:8083
  ![php jessica](./img/14-2.png)

## No.15

atreides Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada grimoire.

### POST /auth/register

### Client

```
echo '
{
  "username": "kelompokit07",
  "password": "passwordit07"
}' > register.json

```

### Testing

```
ab -n 100 -c 10 -p register.json -T application/json http://atreides.it07.com:8081/api/auth/register
```

![test register](./img/15.png)

## No.16

### POST /auth/login

### Client

```
echo '
{
  "username": "kelompokit07",
  "password": "passwordit07"
}' > login.json
```

### Testing

```
ab -n 100 -c 10 -p login.json -T application/json http://atreides.it07.com:8081/api/auth/login
```

![test login](./img/16.png)

## No.17

### GET /me

### Client

1. install dependensi

```
apt-get update
apt-get install jq -y
```

2. Jalankan command berikut

```
curl -X POST -H "Content-Type: application/json" -d @login.json http://atreides.it07.com:8081/api/auth/login > login_output.txt

token=$(cat login_output.txt | jq -r '.token')
```

### Testing

```
ab -n 100 -c 10 -H "Authorization: Bearer $token" http://atreides.it07.com:8081/api/me
```

![test get](./img/17.png)

## No.18

Untuk memastikan ketiganya bekerja sama secara adil untuk mengatur atreides Channel maka implementasikan Proxy Bind pada Stilgar untuk mengaitkan IP dari Leto, Duncan, dan Jessica.

### Stilgar (Load Balancer)

1. install dependensi

```
apt-get update
apt-get install nginx
```

2. lakukan edit di `/etc/nginx/sites-available/laravel`

```
upstream workers {
    server 10.67.2.2:8081;
    server 10.67.2.3:8082;
    server 10.67.2.4:8083;
}

server {
        listen 80;
        server_name atreides.it07.com;

        location / {
        proxy_pass http://workers;
        }
}
```

3. Lakukan symlik

```
ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/laravel
```

4. restart nginx

```
service nginx restart
```

note : jangan lupa mengubah ip di `/etc/bind/jarkom_it07/atreides.it07.com` menjadi ip stilgar

### Testing

```
ab -n 100 -c 10 -p login.json -T application/json http://atreides.it07.com/api/auth/login
```

![test 18](./img/18.png)

## No.19

Untuk meningkatkan performa dari Worker, coba implementasikan PHP-FPM pada Leto, Duncan, dan Jessica. Untuk testing kinerja sebanyak tiga percobaan dan lakukan testing sebanyak 100 request dengan 10 request/second kemudian berikan hasil analisisnya pada PD

### Leto, Duncan, Jessica (Laravel Worker)

- percobaan 1

```
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
```

- percobaan 2

```
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
```

- percobaan 3

```
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
```

```
service php8.0-fpm restart
service nginx restart
```

### Testing Client

```
ab -n 100 -c 10 http://atreides.it07.com/
```

- percobaan 1
  ![coba 1](./img/19-1.png)

- percobaan 2
  ![coba 2](./img/19-2.png)

- percobaan 3
  ![coba 3](./img/19-3.png)

## No.20

Nampaknya hanya menggunakan PHP-FPM tidak cukup untuk meningkatkan performa dari worker maka implementasikan Least-Conn pada Stilgar. Untuk testing kinerja dari worker tersebut dilakukan sebanyak 100 request dengan 10 request/second

### Stilgar (Load Balancer)

1. tambahkan least_conn; di /etc/nginx/sites-available/laravel

```
upstream worker {
    least_conn;
    server 10.67.2.2:8081;
    server 10.67.2.3:8082;
    server 10.67.2.4:8083;
}

server {
        listen 80;
        server_name atreides.it07.com;

        location / {
        proxy_pass http://workers;
        }
}
```

2. restart nginx

```
service nginx start
```

### Testing Client

```
ab -n 100 -c 10 http://atreides.it07.com/
```

![test 20](./img/20.png)
