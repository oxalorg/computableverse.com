---
title: Fix Django Invalid HTTP_HOST header emails
tags:
    - django
    - nginx
    - fix
date: 2017-02-26
---

It's been a long time since I deployed a django application on the internet. At
first, I had no idea about the features of Django and was running it just like
any other flask app. But soon, I came across the  wonderful **Error Reporting**
module and I quickly realised how I had been missing something like this in my
Flask deployments.

But soon, I started getting a TON of `Invalid HTTP_HOST header`. I tried to
take a look into what exactly what happening.

<!--more-->

![tons of invalid host errors](/assets/images/django-errors.png)

Firstly, I have a couple sites hosted on my server. Some of them are served via
`https` and some aren't. When I took a closer look into the error reports, I
could see that none of them had a *request url* of earthlyhumans.com (my django
app). They had the request of one of my other websites, but it somehow wasn't
being caught by their nginx configs.

So I took a look into how nginx choses a configuration for a particular
request. First, it will check if a particular config has a valid `listen`
directive for the incoming request. If it does, then it moves onto checking the
`server_name` directive. If neither happens, it redirects to the `default`
block.

I already had a default block configured as follows..

```
server {
    listen 80;
    return 444;
}
```

..and yet urls were getting passed onto my Django application.

```
/etc/nginx/sites-available$ tree
.
|-- default
|-- earthlyhumans.com.conf
|-- example.com.conf
`-- example2.com.conf

0 directories, 4 files
```

This is how my configuration looked. Now the problem was that why weren't the
requests getting redirected to one of my other applications.

Turns out, the "default" server in nginx is the first server block it reads i.e
sorted alphabetically, unless you have the `default_server` option listed in
the `listen` directive.

But wait a minute, `default` block is still the first listed server block. But
silly me, I hadn't added a listen block for port 443. So it went ahead and
found the first block with port 443 and matched it with my django server block.

So I simply changed my default config to

```
server {
    listen 80 default_server;
    return 444;
}

server {
    listen 443 default_server;
    server_name _; # This can be omitted.
    return 444;
}
```

> special nginx’s non-standard code 444 is returned that closes the connection.

That seemed to have fixed all my issues. You can also explicitly rename `default`
file to something like `0000-default` which makes sure that it's the first
config to be loaded.


References:

- [nginx request processing](http://nginx.org/en/docs/http/request_processing.html)
- [nginx beginners guide](http://nginx.org/en/docs/beginners_guide.html)

<!-- date: 2016-08-25 -->
