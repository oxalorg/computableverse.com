---
tags:
    - guide
    - python
    - publishing
    - pypi
date: 2016-07-30T00:00:00Z
title: Guide to easy publishing and distributing your python application
slug: guide-publish-distribute-python-app
---

Let me be real for a second. It's a goddamn pain to get your python app distributed easily, unless you already know how to. Then it's a breeze. Here's a clean, small, and quick guide explaining just that. No bullshit.

<!--more-->

First `cd` into your project folder, preferably with `vitrualenv` active. Then create a `setup.py` file in the directory similar to this:

```python
from setuptools import setup
from proj import _VERSION
setup(
    name='<proj>',
    packages=['<proj>'],
    version=_VERSION, 
    description='<proj>',
    long_description='Please visit https://github.com/MiteshNinja/<proj> for more details.',
    author='Mitesh Shah',
    author_email='mitesh@miteshshah.com',
    url='https://github.com/MiteshNinja/<proj>',
    download_url='https://github.com/MiteshNinja/<proj>/tarball/' +
    _VERSION,
    keywords=['python', 'proj'],
    classifiers=[],
    install_requires=[
        'package1', 'package2', 'package3'
    ],
    entry_points={
        'console_scripts': [
            'proj=proj:main',
        ],
    })
```

Now install the binary using:

```
python3 setup.py bdist_wheel
pip3 install dist/dystic...[TAB to autocomplete]
```

The application will get installed and a `dist` and `build` directory will be also be created. 

With the `virtualenv` active, make sure the application got installed by either running the command line binary, or running a python interpreter and checking as follows:

```python3
>>> import dystic
>>> dystic
<module 'dystic' from '/home/ox/Dropbox/Projects/dystic/venv/lib/python3.5/site-packages/dystic/__init__.py'>
```

Now inside your `proj/__init__.py` file, include a variable as follows:

```python
_VERSION = 0.1.0
```

You only need to change this version and commit whenever making a version change, ofcourse also rebuilding the wheels.

To distribute the application on `pypi`, go to https://pypi.python.org/pypi and create an account and create a file `~/.pypirc` as follows:

```
[distutils]
index-servers=
    pypi
    pypitest

[pypitest]
repository = https://testpypi.python.org/pypi
username = MiteshNinja
password = password

[pypi]
repository = https://pypi.python.org/pypi
username = MiteshNinja
password = password
```

*Note: you can also create an account on pypitest server to test your app beforehand.*

Now for uploading you need `twine`. Install as:

```
pip3 install twine
```

To upload to pypi, simply run:

```
twine upload dist/<proj>-<version>-py3-none-any.whl
# or any .whl file created in dist folder
```

Voila. That's about it. You can now `pip3 install <proj>` from anywhere :)
