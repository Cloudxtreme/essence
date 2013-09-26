class Essence.Collections.Timelets extends Backbone.Collection
  model: Essence.Models.Timelet
  localStorage: new Backbone.LocalStorage 'Timelets'
