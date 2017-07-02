---
date: 2017-01-08T16:00:36+05:30
title: setup uwsgi emperor vassal
draft: true
tags:
    - python
    - uwsgi
    - web
    - nginx
---



<!--more-->

1. Make an init script for the uwsgi emperor at `/etc/init/uwsgi_emperor.conf`:

    ```
    [Unit]
    Description=uWSGI Emperor
    After=syslog.target

    [Service]
    ExecStart=/root/uwsgi/uwsgi --ini /etc/uwsgi/emperor.ini
    # Requires systemd version 211 or newer
    # This puts our sockets in /run/uwsgi/
    RuntimeDirectory=uwsgi
    Restart=always
    KillSignal=SIGQUIT
    Type=notify
    # No need of this because we have included `logto` in emperor.ini
    # StandardError=syslog
    NotifyAccess=all

    [Install]
    WantedBy=multi-user.target
    ```
    
2. Create the required directories for the emperor and it's vassals. 

	```
    mkdir -p /etc/uwsgi/vassals
    mkdir -p /var/log/uwsgi/vassals
    ```
    
3. Create a basic emperor config `/etc/uwsgi/emperor.ini`

    ```
    [uwsgi]
    emperor = /etc/uwsgi/vassals

    die-on-term = true
    vacuum = true

    uid = www-data
    gid = www-data

    logto = /var/log/uwsgi/emperor.log
    ```
  
4. Create a basic vassal config `/etc/uwsgi/vassals/example.com.uwsgi.ini`

    ```
    [uwsgi]
    uid = www-data
    gid = www-data
    chdir = /var/www/example.com/public
    home = /var/www/example.com/public/venv

    master = true
    module = wsgi
    callable = application

    #cheaper = 1
    #cheaper-inital = 1
    #cheaper-step = 1
    processes = 1

    socket = /tmp/%n.sock
    stats = /tmp/%n_stats.sock
    chmod-socket = 644
    vacuum = true

    die-on-term = true
    harakiri = 30

    # location of log files
    logto = /var/log/uwsgi/vassals/%n.log
    ```
    
5. Pass requests from nginx to our uwsgi socket.
	
    ```
    location / {
      include uwsgi_params;
      uwsgi_pass unix:///tmp/example.com.uwsgi.sock;
   	}
	```

6. 














