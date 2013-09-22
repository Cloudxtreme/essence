Timelets::Application.routes.draw do

  #if %w(development test).include? Rails.env
  #  require 'jasminerice'
  #  mount Jasminerice::Engine, at: '/jasmine', via: :get
  #end

  get '/' => 'bootstrap#app'

  # Catch all route for bootstrapping the RECOMY Backbone application.
  # Needs to be below ActiveAdmin
  # 
  get '*path' => 'bootstrap#app'

end
