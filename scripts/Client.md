# Script Client (Dmitri dan Paul)

- [init](#init)
- [cred](#credential)
- [17-test](#no-17)

## Init

- `init-script.sh`

```bash
apt-get update
apt-get install dnsutils apache2-utils lynx jq -y
```

## credential

- `credential.json`
```json
{
  "username": "kelompokit07",
  "password": "passwordit07"
}
```

## no-17

```bash
curl -X POST -H "Content-Type: application/json" -d @credential.json http://atreides.it07.com:8081/api/auth/login > login_output.txt

token=$(cat login_output.txt | jq -r '.token')

ab -n 100 -c 10 -H "Authorization: Bearer $token" http://atreides.it07.com:8081/api/me

```
