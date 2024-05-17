# Script Arakis

- [init](#init)

## Init

- `init-script.sh`
```bash
echo 'SERVERS="10.67.3.2"
INTERFACES="eth1 eth2 eth3 eth4"
OPTIONS=""
' > /etc/default/isc-dhcp-relay

service isc-dhcp-relay restart
```