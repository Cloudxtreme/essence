require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'deleting two previously created timelets' do
    create_timelet 'My first timelet', 15
    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_field 'name', with: 'My first timelet'
      page.should have_field 'name', with: 'My second timelet'

      find_field('name', with: 'My first timelet').click

      # Make sure the previous detail box is collapsed
      page.should have_field 'duration', with: '15'
      page.should have_no_field 'duration', with: '30'
      page.should have_css '.details .delete'

      find('.delete').click

      page.should have_no_field 'name', with: 'My first timelet'
      page.should have_field 'name', with: 'My second timelet'

      find_field('name', with: 'My second timelet').click
      page.should have_field 'duration', with: '30'
      page.should have_css '.details .delete'
      first('.delete').click

      page.should have_no_field 'name', with: 'My first timelet'
      page.should have_no_field 'name', with: 'My second timelet'
      page.should have_content "You didn't create any timelets yet."
    end
  end

end
