Essence::Application.routes.draw do

  get '/' => 'backbone#start'

  # Pass all routes to the Backbone application.
  # 
  get '*path' => 'backbone#start'

end
