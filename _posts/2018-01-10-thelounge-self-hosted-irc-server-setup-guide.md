---
title: "TheLounge: self-hosted IRC server setup guide"
date: 2018-01-10
slug: thelounge-self-hosted-irc-server-setup-guide
---

This is a simple guide to setting up [TheLounge](https://github.com/thelounge/lounge)
self hosted IRC server.

The official docs are a bit shaky, and I ran across some issues with docker so I decided
to host thelounge without docker.

<!--more-->

I'm assuming that we're using Ubuntu 16.04 here.

## Steps

First we install thelounge from Npm:

```
npm install -g thelounge
```

Now we create certificates for HTTPS/TLS/SSL:

```
mkdir -p $HOME/.lounge
cd $HOME/.lounge
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out cert.pem
```

Now run `lounge start` and see if a server sets up. By default the server will serve
on port 9000 and will not have TLS enabled. 

Edit this file `$HOME/.lounge/config.js` and enable tls and setup the absolute paths
to `key.pem` and `cert.pem` we created earlier.

`lounge start` again and see if things work!

Now we need to run it in background and make the server restart if something goes wrong,
this can be done using a systemd service:

Copy the following contents into `/etc/systemd/system/lounge.service`:

```
[Unit]
Description=The Lounge IRC client
After=thelounge.service

[Service]
Type=simple
ExecStart=/usr/bin/lounge start
User=mitesh #your username here
Group=mitesh
Restart=always
RestartSec=5
StartLimitInterval=60s
StartLimitBurst=3

[Install]
WantedBy=default.target
```

Now simply run: 

```
systemctl enable lounge
systemctl start lounge
```

And VOILA! Go to `https://your.server.i.p:<PORT-configured-in-config.js>/` and enjoy!
