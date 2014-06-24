require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'loading an existing timelet' do
    create_timelet 'My first timelet', 15
    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      expect(page).to have_field 'name', with: 'My first timelet'
      expect(page).to have_field 'name', with: 'My second timelet'

      load_timelet 'My second timelet'
    end

    within 'section.clock' do
      expect(page).to have_content '30'
    end

    within 'section.timelets' do
      load_timelet 'My first timelet'
    end

    within 'section.clock' do
      expect(page).to have_content '15'
    end
  end

end
