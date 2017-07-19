# Copyright (C) Schweizerische Bundesbahnen SBB, 2016
# Python 3.4
# Cimon
__author__ = 'florianseidl'

# accept the free sbb accept page ("Gratis ins Internet") if redirected to it
# simple script that requests search.ch and checks if there is a redirect to freewlan.sbb.ch

from urllib import request
from os import system

class DetectRedirectToAcceptPage(request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, hdrs, newurl):
        # we where redirected (301, 302, 303...).
        # It is 303 for freesbb but ignore it may change, just check the url.
        if "freewlan.sbb.ch" in newurl:
            global freesbb_redirect_url
            freesbb_redirect_url = newurl
        # in any case just go on as usual (follow the redirect location)
        return request.HTTPRedirectHandler.redirect_request(self, req, fp, code, msg, hdrs, newurl)

opener = request.build_opener(DetectRedirectToAcceptPage)

# global variable - very ugly but everything else would be an overkill here
freesbb_redirect_url = None

# request to see if we get redirected (if not all is fine)
# using search.ch because it is relatively fast and not https like google (no certificate issues)
# ignoring the result - anything but a 2xx or redirect will lead to an exception
opener.open("http://neverssl.com")

# if it is welcome_back we can "click the button"
if freesbb_redirect_url and "welcome_back" in freesbb_redirect_url:
    req = request.Request(str(freesbb_redirect_url), data=None, headers={}, method="POST")
    opener.open(req)
