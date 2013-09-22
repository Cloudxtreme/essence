# Custom version of Backbone.History::loadUrl providing
# locale support.
#
# It works like the original 'loadUrl' method but will
# intercept the first path fragment if it is a valid
# locale. URLs will be prefixed with a locale fragment
# if none exists.
#
# @example Viewing the first job with the default locale
#   Backbone.history.navigate /jobs/1
#
# @example Viewing the first job with a German locale
#   Backbone.history.navigate /de/jobs/1
#
# @see Backbone.History::loadUrl
#
Backbone.History::loadUrl = (fragmentOverride) ->
  fragment = @fragment = @getFragment(fragmentOverride)

  locale = fragment.split('/')[0]
  if Essence.application.isValidLocale locale
    Essence.application.setLocale locale
    fragment = fragment.split('/').slice(1).join('/')

  unless locale is sessionStorage['language']
    locale = sessionStorage['language']
    @navigate "#{ locale }/#{ fragment }", { trigger: false, replace: true }

  matched = _.any @handlers, (handler) ->
    if handler.route.test(fragment)
      handler.callback(fragment)
      return true
  matched
