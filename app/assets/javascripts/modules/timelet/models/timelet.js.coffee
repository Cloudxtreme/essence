# A model for a timelet
#
class Essence.Models.Timelet extends Backbone.Model
  localStorage: new Backbone.LocalStorage 'Timelets'
  defaults:
    name: 'New timelet'
    running: false
    duration: 0
    timer: '--'

  validate: (attrs, options) ->
    unless parseInt(attrs.timer) > 0
      return 'Timer is too small'
    unless parseInt(attrs.duration)
      return 'Invalid duration'
    unless parseInt(attrs.duration) > 0
      return 'Duration is too small'
