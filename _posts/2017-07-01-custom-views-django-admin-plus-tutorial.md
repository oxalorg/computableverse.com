---
date: 2017-07-01
title: "Custom views using django-adminplus, a quick tutorial"
tags:
  - python
  - django
slug: custom-views-django-admin-plus-tutorial
---

I couldn't find an easy to get started
guide/tutorial for creating custom views for
[django-admin](https://docs.djangoproject.com/en/1.11/ref/contrib/admin/) 
so decided to write one!

If your django-admin is being used by people other than the
developers, or perhaps your business flows are complex and
non-traditional, soon you'll find yourself wanting to go
beyond what django-admin has to offer. You'll have the feeling
to write an entire custom app finetuned to the whims of your
requirements. No more custom hacks, no more extending template
blocks, no morea messing around with pesky inline javascript.
It's pure bliss.. But you must resist such temptation (or
atleast somewhat).

<!--more-->

Instead of creating an entire different app for processes
which need to be carried out by non-tech staff, I went ahead and
started looking on how to add custom views into django-admin
home page.

Here's how it will look:

![custom view
django-adminplus](/assets/images/django-adminplus.png)

An easy way to do this is using the package
[django-adminplus](https://github.com/jsocol/django-adminplus)
. The entire package is extremely small (I encourage you to
read the source). It does one thing, and does it relatively
well. django-adminplus will allow you to:

* Take a normal view and embedd it into your django-admin installation.
* Wrap the view using `admin_view` to provide appropirate
  permissions and making it noncacheable.
* It will also put this view on your django-admin index page
  (the page you land on after logging into admin)

Lets get started.

## Installation and Setup

Go ahead and add adminplus to `INSTALLED_APPS`,
replace `django.contrib.admin` with
`django.contrib.admin.apps.SimpleAdminConfig` and add these
lines to the main `urls.py` file:

```python
from adminplus.sites import AdminSitePlus

admin.site = AdminSitePlus()
admin.sites.site = admin.site # extra line
admin.autodiscover()

urlpatters = [
    ...
]
```

For recent versions of django we need to add that extra line not
present in the documentation for admin decorators to work
properly (without it, some of your models won't register with
admin).

## Creating a custom view

Now lets head on to an `admin.py` file of any of your django
apps and create this custom view.

```python
@admin.site.register_view('hello', urlname='custom_hello', name='Greets you with a hello')
def custom_hello(request):
    return render(request, 'myapp/hello.html', {})
```

Note `register_view` instead of `register`.

We can also use a class based view:

```python
class CustomHelloView(View):
    def get(self, request):
        return render(request, 'myapp/hello.html', {})

admin.site.register_view('hello', view=CustomHelloView.as_view(), urlname='custom_hello', name='Greets you with a hello')
```

## Extending admin properly

Now you can use those views independently and completely
detachhed from admin. But instead I'd recommend making them fit
in with the remaining of the admin site.

We can do this by extending the admin base template as follows:

{% comment %}
```jinja
# myapp/custom_admin_base.html
{% extends "admin/base_site.html" %}
{% load static %}

{% block extrastyle %}
<link rel="stylesheet" href="{% static 'vendor/css/bootstrap.min.css' %}">
<link rel="stylesheet" href="{% static 'css/admin.css' %}">
{% endblock %}

{% block extrahead %}
<script src="{% static 'vendor/js/jquery.min.js' %}"></script>
<script src="{% static 'vendor/js/bootstrap.min.js' %}"></script>
{% endblock %}

{% block footer %}
{{ block.super }}
<script src="{% static 'js/admin.js' %}"></script>
{% endblock %}
```
{% endcomment %}

Now create templates to be used in your views like:

{% comment %}
```jinja
# myapp/hello.html
{% extends "myapp/custom_admin_base.html" %}

{% block content %}
  <h1>Hello world!</h1>
  <p> from {{ hello_from }} </p>
{% endblock %}
```
{% endcomment %}


For the admin base site to render properly (i.e. for the
"welcome message", "log out", "view site", etc to render)
we need to pass it some context which can be done in our views
using a helper function provided by django:

```python
@admin.site.register_view('hello', urlname='custom_hello', name='Greets you with a hello')
def custom_hello(request):
    context = dict(
        admin.site.each_context(request),
        hello_from="oxalorg"
    )
    return render(request, 'myapp/hello.html', context)
```

### Some tips and tricks

Not all view should be visible on the django admin index page.
We can hide views using an extra keyword argument
`visible=False` in the `register_view` function.

`urlname` is used for `reverse()` and `redirect()` but using the
name directly like `reverse('custom_hello')` may give a
`NoReverseMatch` error. This could most likely be fixed by using
the admin namespace `reverse('admin:custom_hello')`.

That's about it with this small introduction/tutorial with
adding custom views easily. Feel free to post your feedback in
the comments below!
