require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'deleting two previously created timelets' do
    create_timelet 'My first timelet', 15
    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'

      find('span.name', text: 'My first timelet').click

      # Make sure the previous detail box is collapsed
      page.should have_content '15'
      page.should have_no_content '30'
      page.should have_css '.details .delete'

      find('.delete').click

      page.should have_no_content 'My first timelet'
      page.should have_content 'My second timelet'

      find('span', text: 'My second timelet').click
      page.should have_content '30'
      page.should have_css '.details .delete'
      first('.delete').click

      page.should have_no_content 'My first timelet'
      page.should have_no_content 'My second timelet'
      page.should have_content "You didn't create any timelets yet."
    end
  end

end
