require 'spec_helper'

feature 'Editing timelets' do

  background do
    visit '/timelet'
  end

  scenario 'edit a newly created timelet' do
    create_timelet 'My first timelet', 33

    within 'section.timelets' do
      expect(page).to have_field 'name', with: 'My first timelet'

      find_field('name', with: 'My first timelet').click
      expect(page).to have_field 'duration', with: '33'

      find_field('duration').set '67'
      find_field('name').set 'My edited timelet'
      find('.details label').click

      find('.save').click

      expect(page).to have_no_field 'name', with: 'My first timelet'
      expect(page).to have_field 'name', with: 'My edited timelet'
    end
  end
end
