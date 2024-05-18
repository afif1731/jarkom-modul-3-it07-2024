# Script Mohiam (DHCP Server)

- [init](#init-0-5)

## Init (0-5)

- `init-script.sh`
```bash
apt-get update
apt-get install isc-dhcp-server -y

echo 'INTERFACESv4="eth0"
OPTIONS=""

' > /etc/default/isc-dhcp-server

echo 'subnet 10.67.3.0 netmask 255.255.255.0 {
    option routers 10.67.3.1;
    option broadcast-address 10.67.3.255;
}

subnet 10.67.4.0 netmask 255.255.255.0 {
    option routers 10.67.4.1;
    option broadcast-address 10.67.4.255;
}

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
' > /etc/dhcp/dhcpd.conf

rm /var/run/dhcpd.pid

service isc-dhcp-server restart
```

# 12 Script

- `12-script.sh`
```bash
echo 'subnet 10.67.3.0 netmask 255.255.255.0 {
    option routers 10.67.3.1;
    option broadcast-address 10.67.3.255;
}

subnet 10.67.4.0 netmask 255.255.255.0 {
    option routers 10.67.4.1;
    option broadcast-address 10.67.4.255;
}

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

host Paul {
    hardware ethernet ea:bd:80:c5:98:e2;
    fixed-address 10.67.2.203;
    option host-name "Paul";
}
' > /etc/dhcp/dhcpd.conf

rm /var/run/dhcpd.pid

service isc-dhcp-server restart
```