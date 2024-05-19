# Script Client (Dmitri dan Paul)

- [init](#init)

## Init

- `init-script.sh`

```bash
apt-get update
apt-get install dnsutils apache2-utils lynx -y
```

## no-15

```bash
echo '
{
  "username": "kelompokit07",
  "password": "passwordit07"
}' > register.json

ab -n 100 -c 10 -p register.json -T application/json http://atreides.it07.com:8081/api/auth/register

```

### no-16

```bash
echo '
{
  "username": "kelompokit07",
  "password": "passwordit07"
}' > login.json

ab -n 100 -c 10 -p login.json -T application/json http://10atreides.it07.com:8081/api/auth/login

```

### no-17

```bash
apt-get update
apt-get install jq -y

curl -X POST -H "Content-Type: application/json" -d @login.json http://atreides,it07.com:8081/api/auth/login > login_output.txt

token=$(cat login_output.txt | jq -r '.token')

ab -n 100 -c 10 -H "Authorization: Bearer $token" http://atreides.it07.com:8081/api/me

```
