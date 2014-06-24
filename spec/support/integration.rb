module Support

  module Integration

    # Fill in a value into an element with the attribute contentEditable.
    #
    # @param [String] editable selector for the target element
    # @param [String] value the value to fill in
    # @param [Hash] options options to pass to the node finder
    #
    def fill_in_editable(editable, value, options = {})
      node = page.first :css, editable, options
      raise "Node not found" unless node

      # Activate the element
      node.click

      # Delete current value
      current_value = node.text
      current_value.length.times do
        node.native.send_keys :delete
      end

      node.native.send_keys value.to_s
    end

    # Create a timelet using the UI.
    #
    # @param [String] name the name of the timelet
    # @param [Integer] duration the duration of the timlet
    # @param [Boolean] loop whether the timelet should loop
    # @param [Boolean] loop whether the timelet alerts
    #
    def create_timelet(name, duration, loop = false, alert = false)
      within 'section.timelets' do 
        find('.add').click
        expect(page).to have_content 'Duration:'
        find_field('name', with: 'New Timelet').set name
        find_field('duration', with: '0').set duration.to_s
        check('loop') if loop
        check('alert') if alert
        find('.details label').click
        find('.save').click
      end
    end

    # Loads a named timelet from the list
    #
    # @param [String] name the name of the timelet
    #
    def load_timelet(name)
      find_field('name', with: name).find(:xpath, "../../a").click
    end

    # Initializes a fake clock in the browser.
    #
    def fake_time
      page.execute_script 'window.clock = sinon.useFakeTimers();'
    end

    # Skip time ahead in the browser.
    #
    # Requires to run @fake_time before.
    #
    # @param [Integer] duration Time in seconds
    #
    def advance(duration)
      page.execute_script "window.clock.tick(#{ duration * 1000 });"
    end
  end

end
