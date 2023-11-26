# sudo certbot certonly --authenticator dns-azure --preferred-challenges dns --noninteractive --agree-tos --email r.heuvel89@gmail.com --dns-azure-config ~/.secrets/certbot/azure.ini -d vtt.t7l.org -d *.vtt.t7l.org
sudo certbot renew
sudo cp /etc/letsencrypt/live/sub.domain.com/fullchain.pem /usr/share/nginx/certificates/
sudo cp /etc/letsencrypt/live/sub.domain.com/privkey.pem /usr/share/nginx/certificates/
nginx -s reload
