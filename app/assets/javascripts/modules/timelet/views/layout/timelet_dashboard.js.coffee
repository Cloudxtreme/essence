# Timelet dashboard area.
#
class Essence.Views.TimeletDashboard extends Backbone.Marionette.Layout
  template: 'modules/timelet/templates/dashboard'

  regions:
    clock:    'article.clock'
    timelets: 'article.timelets'

  initialize: ->
    @model = new Essence.Models.Timelet duration: 50
    @collection = new Backbone.Collection

  onRender: ->
    @clock.show new Essence.Views.Clock(model: @model, parent: @)
    @timelets.show new Essence.Views.Timelets(collection: @collection, parent: @)
