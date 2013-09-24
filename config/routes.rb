Essence::Application.routes.draw do

  get '/' => 'bootstrap#app'

  # Catch all route for bootstrapping the RECOMY Backbone application.
  # Needs to be below ActiveAdmin
  # 
  get '*path' => 'bootstrap#app'

end
