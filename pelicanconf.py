#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Christine Man'
SITENAME = u'glorybox'
SITEURL = ''

TIMEZONE = 'Europe/London'

DEFAULT_LANG = u'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None

# Blogroll
LINKS =  (('Pelican', 'http://getpelican.com/'),
          ('Python.org', 'http://python.org/'),
          ('Jinja2', 'http://jinja.pocoo.org/'),
          ('You can modify those links in your config file', '#'),)

# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

DEFAULT_PAGINATION = 10


# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True


THEME = 'themes/basic'

PLUGIN_PATH = 'pelican-plugins'

PLUGINS = ['liquid_tags.soundcloud', 'liquid_tags.youtube', 'liquid_tags.spotify',
         'liquid_tags.vimeo', 'liquid_tags.spotifylist', 'sitemap']

DISQUS_SITENAME = 'introtheglorybox'

TAG_CLOUD_STEPS = 4
TAG_CLOUD_MAX_ITEMS = 100
