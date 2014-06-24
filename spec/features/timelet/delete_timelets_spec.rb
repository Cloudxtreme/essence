require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'deleting two previously created timelets' do
    create_timelet 'My first timelet', 15
    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      expect(page).to have_field 'name', with: 'My first timelet'
      expect(page).to have_field 'name', with: 'My second timelet'

      find_field('name', with: 'My first timelet').click

      # Make sure the previous detail box is collapsed
      expect(page).to have_field 'duration', with: '15'
      expect(page).to have_no_field 'duration', with: '30'
      expect(page).to have_css '.details .delete'

      find('.delete').click

      expect(page).to have_no_field 'name', with: 'My first timelet'
      expect(page).to have_field 'name', with: 'My second timelet'

      find_field('name', with: 'My second timelet').click
      expect(page).to have_field 'duration', with: '30'
      expect(page).to have_css '.details .delete'
      first('.delete').click

      expect(page).to have_no_field 'name', with: 'My first timelet'
      expect(page).to have_no_field 'name', with: 'My second timelet'
      expect(page).to have_content "You didn't create any timelets yet."
    end
  end

end
