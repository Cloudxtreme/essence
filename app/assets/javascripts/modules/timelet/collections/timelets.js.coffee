class Essence.Collections.Timelets extends Backbone.Collection
  model: Essence.Models.Timelet
  localStorage: new Backbone.LocalStorage 'Timelets'

  # Marks all timelets as not loaded.
  #
  unload: ->
    timelet.unload() for timelet in @models
