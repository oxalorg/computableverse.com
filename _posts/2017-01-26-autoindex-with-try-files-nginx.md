---
title: "Autoindex with try_files in nginx"
date: 2017-01-26
tags:
    - nginx
slug: nginx-autoindex-try-files
---

It's a bit nitpicky but after setting up a couple of websites,
I always run across this issue and have to randomly guess and
try until I get it right. So let's change that and understand
the proper way to implement nginx with both `try_files`
directive and automatic directory index using `autoindex on`
with a working 404 page on incorrect urls.

Let's say we have a particular location block in which we want
these features to co-exist. What we need is something like this:

1. Match uri exactly
* Show `index.html` if it is present
* Show `{uri}.html` if it is present
* Show an automated directory if folder exists
* Otherwise show a 404 error

<!--more-->

2nd point is implemented using an inbuilt nginx directive:

    index index.html

Rest of the scenarios are implemented using:

    try_files $uri $uri.html $uri/ =404;
    autoindex on;

These are checked in order until one of the condition satisfies.

Entire config:

```
server {
    listen 80;
    server_name rogue.oxal.org;
    server_tokens off;
    root /var/www/rogue.oxal.org/public;
    index index.html;

    location / {
        autoindex on;
        try_files $uri $uri.html $uri/ =404;
    }

    error_page 404 /404.html;
}
```
