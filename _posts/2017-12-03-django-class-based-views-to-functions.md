---
title: Django converting class based views to function based views
date: 2017-12-03
slug: django-class-based-views-to-functions
tags:
  - python
  - django
---

After taking a look at some the class based views I wrote, I
realised that I didn't really need all the "flexibility" of
inheritance, or classes. My views were simple enough to just use
a function, even when a view was handling both `GET` and `POST`
requests differently.

<!--more-->

Here's an example class based view code (CBV) I was recently
working on:

```python
@method_decorator(login_required, name='dispatch')
class OrderSuccess(View):
    template_name = 'orders/order_success.html'
    form_class = UserAdditionalInfoForm

    # Common code for both get and post reqs
    def dispatch(self, request, *args, **kwargs):
        order_id = int(kwargs['order_id'])
        order = get_object_or_404(Order, pk=order_id)
        if order.user != request.user:
            raise Http404
        self.order = order
        return super().dispatch(request, *args, **kwargs)

    def get(self, request, order_id):
        user_additional_info_form = None
        if not request.user.first_name:
            user_additional_info_form = self.form_class(
                instance=request.user)

        if request.session.get('redirected_after_placing_order', False):
            request.session.pop('redirected_after_placing_order', None)
            return self.render_form(user_additional_info_form,
                                    clear_client_cart=True)
        return self.render_form(user_additional_info_form, clear_client_cart=False)

    def post(self, request, order_id):
        form = self.form_class(request.POST, instance=request.user)
        if form.is_valid():
            form.save()
            # use messages to indicate succesful update
            return redirect(reverse_lazy('order_success',
                                         kwargs={'order_id': order_id}))
        return self.render_form(form, clear_client_cart=False)

    # common code for both get and post reqs
    def render_form(self, user_additional_info_form, clear_client_cart=True):
        return render(self.request, self.template_name, {
            'order': self.order,
            'user_additional_info_form': user_additional_info_form,
            'clear_client_cart': clear_client_cart
        })
```

I'm not extending from a previously existing CBV. So the
benefits of inheritance are non-existant in this example. But
how many of your views need to be extended off of existing
views?

If you notice carefully my CBV has taken a structural form
somewhat similar to this:

```
class OrderSuccess
    def run_some_common_code_at_start()
        ...

    def run_if_get_request()
        ...

    def run_if_post_request()
        ...

    def run_some_common_code_at_end()
        ...
```

This looks very similar to a... (yup you guessed it right),
a **function**.

So I took that CBV and converted it into this much easy to
understand function:

```python
@login_required
def order_success_view(request, order_id):
    order = get_object_or_404(Order, pk=order_id)
    if order.user != request.user:
        raise Http404

    form = None
    clear_client_cart = False

    if request.method == 'GET':
        if not request.user.first_name:
            form = UserAdditionalInfoForm(instance=request.user)

        if request.session.get('redirected_after_placing_order', False):
            request.session.pop('redirected_after_placing_order', None)
            clear_client_cart = True
    elif request.method == 'POST':
        form = UserAdditionalInfoForm(request.POST, instance=request.user)
        if form.is_valid():
            form.save()
            return redirect(reverse_lazy('order_success',
                                         kwargs={'order_id': order_id}))

    context = {
        'order': order,
        'user_additional_info_form': form,
        'clear_client_cart': clear_client_cart,
    }
    return render(request, 'orders/order_success.html', context)
```

Not only does it look more readable, there's less chances of
error because there is no internal state which can be touched up
by different functions. I don't need to track any dependency
that `self.a()` must not be called at the start of `self.get()`
etc.

Maybe this example of a view is more suited for a FBV, I'll be
keeping an open mind and try to find where CBVs really shine. I
haven't come across any such complex flows where I've really
felt CBVs a godsend, so I'll keep looking!

What are your thoughts? Post in the comments below ^_^
