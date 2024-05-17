# Script Irulan (DNS Server)

- [Init (0-5)](#init-0-5)

## Init (0-5)

- `init-script.sh`
```bash
echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

service bind9 start

mkdir -p /etc/bind/jarkom_it07

echo 'options {
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
' > /etc/bind/named.conf.options

echo 'zone "atreides.it07.com" {
	type master;
	file "/etc/bind/jarkom_it07/atreides.it07.com";
};

zone "harkonen.it07.com" {
	type master;
	file "/etc/bind/jarkom_it07/harkonen.it07.com";
};
' > /etc/bind/named.conf.local

echo ';
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
' > /etc/bind/jarkom_it07/atreides.it07.com

echo ';
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
' > /etc/bind/jarkom_it07/harkonen.it07.com

service bind9 restart
```