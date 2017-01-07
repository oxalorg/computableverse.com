---
date: 2016-07-14T00:00:00Z
title: Secure flask-admin using flask-basicauth
slug: flask-admin-using-basicauth
tags:
    - web
    - guide
    - python
    - flask
---

I could not find a way to protect my flask-admin installation at `/admin` using `Flask-BasicAuth`, so I decided to write this for future explorers!

<!--more-->

The flask-admin docs praise the simplicity and awesomeness of using HTTP basic authentication, and also point the user towards a small extenstion which makes this easy process even easier.

> The simplest form of authentication is HTTP Basic Auth. It doesn’t interfere with your database models, and it doesn’t require you to write any new view logic or template code.
> Have a look at Flask-BasicAuth to see just how easy it is to put your whole application behind HTTP Basic Auth.

and then they drop the bomb saying: 

> Unfortunately, there is no easy way of applying HTTP Basic Auth just to your admin interface.

Oh well. I definitely do not want people to log in when they land on my index page, so that rules the above option out.

Thankfully, it's rather quite easy to extend admin views to support `flask-BasicAuth`. We just need to override two functions in our admin `ModelView` class.

```python
class ModelView(sqla.ModelView):
    def is_accessible(self):
        if not basic_auth.authenticate():
            raise AuthException('Not authenticated.')
        else:
            return True

    def inaccessible_callback(self, name, **kwargs):
        return redirect(basic_auth.challenge())
```

Here `basic_auth` is defined as `basic_auth = BasicAuth(app)` directly borrowed from the quickstart section of BasicAuth docs.

If `BasicAuth` can't authenticate the user, it will raise an exception which inturn will call the `inaccessible_callback` which will challenge the user to provide authentication details.

The exception, `AuthException`, is nothing but a simple `HTTPException` provided by `werkzeug`:

```python
from werkzeug.exceptions import HTTPException

class AuthException(HTTPException):
    def __init__(self, message):
        super().__init__(message, Response(
            "You could not be authenticated. Please refresh the page.", 401,
            {'WWW-Authenticate': 'Basic realm="Login Required"'}
        ))
```

Now we can call our admin views normally like this:

```python
admin = Admin(app, name='ninjas-nest')
admin.add_view(ModelView(Post, db.session))
admin.add_view(ModelView(PostFiles, db.session))
```

TADA! All the urls prefixed with `/admin` now require authentication before you can proceed.

WARNING: Please note that this is not secure on it's own. It will send username and password without any encryption. Only use it with HTTPS (SSL/TLS). Also, this does not block ips which have a lot of failed attempts which could lead to security concerns. I will deal with this in a later post.

Let me know if you have any better way of protecting only `flask-admin` in the comments below.
