---
tags:
    - guide
    - web
    - sysadmin
    - nginx
    - ssl
    - https
    - letsencrypt

date: 2016-06-12T00:00:00Z
title: Implement HTTPS using SSL/TLS for FREE within 5 minutes
slug: implement-https-using-ssl-tls-free-fast
---

I reckon I'll need to set up TLS for several sites in the future. Applying the DRY principle, I'm documenting the steps while it's fresh in my head, so that I don't have to waste time 10 months down the line.

So let's keep this short and useful.

<!--more-->

### Install letsencrypt

No wizardry here. Simple as sh. Refer this [guide](https://www.nginx.com/blog/free-certificates-lets-encrypt-and-nginx/) for more details.

```shell
sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
cd /opt/letsencrypt
sudo ./letsencrypt-auto
cd /var/www
mkdir letsencrypt
sudo chgrp www-data letsencrypt
```

### Set up letsencrypt config file and fetch certificates

More info [here](https://gist.github.com/xrstf/581981008b6be0d2224f), but siriusly no need to get too involved. Just run the below script as follows `sh setupLEConfig.sh <your-domain-name-here> <your-email-here>`:

```shell
#!/bin/bash

cat <<EOF > /etc/letsencrypt/configs/$1.conf
domains = $1
rsa-key-size = 4096

# the current closed beta (as of 2015-Nov-07) is using this server
server = https://acme-v01.api.letsencrypt.org/directory

# this address will receive renewal reminders
email = $2

# turn off the ncurses UI, we want this to be run as a cronjob
text = True

# authenticate by placing a file in the webroot (under .well-known/acme-challenge/)
# and then letting LE fetch it
authenticator = webroot
webroot-path = /var/www/letsencrypt/
EOF
```

### Fetch certifcates and verify

Point CA (certificate authority) where to find temporary files used for authenticating that you own the domain.

```shell
server {
    listen 80;
    server_name mitesh.ninja;

    # This block is important
    location /.well-known/acme-challenge {
        root /var/www/letsencrypt;
    }
}
```

Now restart nginx

```
sudo nginx -t && sudo nginx -s reload
```

and actually fetch the certs:

```shell
cd /opt/letsencrypt
./letsencrypt-auto --config /etc/letsencrypt/configs/mitesh.ninja.conf certonly
```

### Final nginx config for https

1. Listen on port 443 (for ssl).  
2. Tell nginx where to find your certificates.  
3. Tell CA (certificate authority) where to find temporary files used for authenticating that you own the domain.  
    - We did this in http server block for first time authentication.  
    - https server block for authentication henceforth.  
4. Rewrite http traffic to https.  

```shell
server {
    ###
    # Replace 'mitesh.ninja' with your own FQDN.
    ##
    listen 443 ssl; # Step 1
    server_name mitesh.ninja;

    # Step 2
    ssl_certificate /etc/letsencrypt/live/mitesh.ninja/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mitesh.ninja/privkey.pem;

    # Step 3
    location /.well-known/acme-challenge {
        root /var/www/letsencrypt;
    }
}
server {
    listen 80;
    server_name mitesh.ninja www.mitesh.ninja;
    return 301 https://$host$request_uri;
}
```

Now restart nginx

    sudo nginx -t && sudo nginx -s reload


**VOILA!** That's it. https live at [https://mitesh.ninja](https://mitesh.ninja). View full nginx conf [here](https://github.com/MiteshNinja/mitesh.ninja/blob/master/conf/mitesh.ninja.conf) :D)

Note: The certificates will expire every 3 months. I haven't set up a cron job atm. I'm researching more about it, trying new stuff and will most likely roll up a small python script to handle auto renewing.
