require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'deleting two previously created timelets' do
    create_clock_timelet 'My first timelet', 15
    find('.add').click
    create_clock_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'

      find('span.name', text: 'My first timelet').click
      page.should have_css '.details .delete'
      first('.delete').click

      page.should have_no_content 'My first timelet'
      page.should have_content 'My second timelet'

      find('span', text: 'My second timelet').click
      page.should have_css '.details .delete'
      first('.delete').click

      page.should have_no_content 'My first timelet'
      page.should have_no_content 'My second timelet'
    end
  end

end
