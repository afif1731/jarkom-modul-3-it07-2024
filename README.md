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
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.67.0.0/16
apt-get update
apt-get install isc-dhcp-relay -y
service isc-dhcp-relay start
```

- Irulan (DNS) - `init-script.sh`
```
apt-get update
apt-get install bind9 -y
```

- Mohiam (DHCP) - `init-script.sh`
```
apt-get update
apt-get install isc-dhcp-server -y
```

- Client - `init-script.sh`
```
apt-get update
apt-get install dnsutils apache2-utils lynx -y
```

- Chani (Database Server) - `init-script.sh`
```
apt-get update
apt-get install mariadb-server -y
```

- Stilgar (Load Balancer) - `init-script.sh`
```
apt-get update
apt-get install nginx -y
```

- PHP Worker - `init-script.sh`
```
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
```
apt-get update
apt-get install apache2 wget unzip php git -y

service apache2 start

git clone https://github.com/martuafernando/laravel-praktikum-jarkom.git laravel_web

mkdir -p /var/www/jarkom_ito7

# meletakkan komponen web
cp /root/laravel_web/* /var/www/jarkom_it07/
```

## No.2
## No.3
## No.4
## No.5
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
