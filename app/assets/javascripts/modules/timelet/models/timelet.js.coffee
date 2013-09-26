# A model for a timelet
#
class Essence.Models.Timelet extends Backbone.Model
  localStorage: new Backbone.LocalStorage 'Timelets'
  defaults:
    running: false
