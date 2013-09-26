# Timelet dashboard area.
#
class Essence.Views.TimeletDashboard extends Backbone.Marionette.Layout
  template: 'modules/timelet/templates/dashboard'

  regions:
    clock:    'article.clock'
    timelets: 'article.timelets'

  initialize: (params) ->
    @model = new Essence.Models.Timelet
    if params.id
      @model.set id: params.id
      @model.fetch()

    @collection = new Essence.Collections.Timelets
    @collection.fetch()

  onRender: ->
    @clock.show new Essence.Views.Clock(model: @model, collection: @collection, parent: @)
    @timelets.show new Essence.Views.Timelets(collection: @collection, parent: @)
