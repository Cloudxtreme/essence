# Timelet dashboard area.
#
class Essence.Views.TimeletDashboard extends Backbone.Marionette.Layout
  template: 'modules/timelet/templates/timelet_dashboard'

  regions:
    preview:   'article.preview'
    inventory: 'article.inventory'

  initialize: ->
    @timelet = new Essence.Models.Timelet duration: 50
    @timelets = new Backbone.Collection

  onRender: ->
    @preview.show new Essence.Views.Clock(model: @timelet, parent: @)
    @inventory.show new Essence.Views.Timelets(collection: @timelets, parent: @)
