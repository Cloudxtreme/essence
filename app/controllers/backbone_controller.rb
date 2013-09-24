# The Backbone controller provides the markup and JavaScript
# code for running the frontend application.
#
class BackboneController < ApplicationController

  # Render the Backbone application
  #
  def start
    respond_to do |format|
      format.html
    end
  end

end
