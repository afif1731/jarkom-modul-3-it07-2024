# Script Laravel Worker

- [Init](#init)

## Init

- `init-script.sh`
```bash
apt-get update
apt-get install apache2 wget unzip php git -y

service apache2 start

git clone https://github.com/martuafernando/laravel-praktikum-jarkom.git laravel_web

mkdir -p /var/www/jarkom_ito7

# meletakkan komponen web
cp /root/laravel_web/* /var/www/jarkom_it07/
```