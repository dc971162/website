# website
Auto setup a HTTPS web server and host a website template
# Usage
Run as `root` user, replace "example.com" to your domain
```
apt -y update
apt-get install -y apache2 certbot python3-certbot-apache unzip
curl -s https://raw.githubusercontent.com/dc971162/website/refs/heads/main/setup.sh | bash -s -- example.com
```
