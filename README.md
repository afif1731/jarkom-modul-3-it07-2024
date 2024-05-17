# Laporan Resmi Praktikum Jarkom Modul 3 - Kelompok IT07

| Nama              | NRP        |
| ----------------- | ---------- |
| Muhammad Afif     | 5027221032 |
| Alma Amira Dewani | 5027221054 |

# Pendahuluan

Praktikum modul 2 jarkom terdiri dari 21 soal yang dikerjakan seluruhnya menggunakan `VM GNS3`. Ketentuan tambahannya adalah node debian untuk praktikum ini harus menggunakan docker image `danielcristh0/debian-buster:1.1`.

Berikut merupakan cara penyelesaian modul oleh kelompok IT07.

## No.0 dan 1

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
up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

- Paul (Client)
```
auto eth0
iface eth0 inet dhcp
up echo nameserver 192.168.122.1 > /etc/resolv.conf
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

- Chani (Database Server) - `init-script.sh`
```bash
apt-get update
apt-get install mariadb-server -y
```

- Stilgar (Load Balancer) - `init-script.sh`
```bash
apt-get update
apt-get install nginx -y
```

- PHP Worker - `init-script.sh`
```bash
apt-get update
apt-get install apache2 wget unzip php -y

service apache2 start

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1lmnXJUbyx1JDt2OA5z_1dEowxozfkn30' -O 'harkonen.zip'
unzip harkonen.zip

mkdir -p /var/www/jarkom_it07

# meletakkan komponen web
cp /root/modul-3/* /var/www/jarkom_it07/
```

- Laraver Worker - `init-script.sh`
```bash
apt-get update
apt-get install apache2 wget unzip php git -y

service apache2 start

git clone https://github.com/martuafernando/laravel-praktikum-jarkom.git laravel_web

mkdir -p /var/www/jarkom_ito7

# meletakkan komponen web
cp /root/laravel_web/* /var/www/jarkom_it07/
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

atreides.it07.com mengarah ke laravel Worker `Leto`

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

sementara harkonen.it07.com mengarah ke laravel Worker `Vladimir`

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

```bash
rm /var/run/dhcpd.pid

service isc-dhcp-server restart
```

## No.3

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

Lakukan ping pada `atreides.it07.com` dan `harkonen.it07.com`, terkadang responsenya akan datang cukup lama,

namun untuk memastikan bahwa sudah bisa terhubung pada DNS server, lakukan nslookup pada `atreides.it07.com` dan `harkonen.it07.com` lalu pastikan bahwa address dari masing masing domain sesuai dengan yang telah dikonfigurasi pada DNS Server.

## No.5

### Mengonfigurasi Leasing Times untuk Subnet Harkonen dan Atreides

Tambahkan lease time pada kedua konfigurasi subnet client dengan ketentuan:

| Client       | Default           | Max               |
| ------------ | ----------------- | ----------------- |
| Harkonen     | 5 menit (300 s)   | 87 menit (5220 s) |
| Atreides     | 20 menit (1200 s) | 87 menit (5220 s) |

- - `/etc/dhcp/dhcpd.conf`
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
## No.7
## No.8
## No.9
## No.10
## No.11
## No.12
## No.13
## No.14
## No.15
## No.16
## No.17
## No.18
## No.19
## No.20
