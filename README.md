# website
Auto setup a HTTPS web server with a fake website hosting
# Usage
Run as `root` user, replace "example.com" to your domain
```
apt -y update
apt-get install -y apache2 certbot python3-certbot-apache unzip
curl -s https://raw.githubusercontent.com/dc971162/website//main/setup.sh | bash -s -- example.com
```
