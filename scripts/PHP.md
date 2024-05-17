# Script PHP Worker

- [Init](#init)

## Init

- `init-script.sh`
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