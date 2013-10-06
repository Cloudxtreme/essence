require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'creating a timelet' do
    create_timelet 'A single timelet', 91

    within 'section.timelets' do
      page.should have_field 'name', with: 'A single timelet'
    end
  end

  scenario 'creating two timelets' do
    create_timelet 'My first timelet', 15

    within 'section.timelets' do
      page.should have_field 'name', with: 'My first timelet'
    end

    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_field 'name', with: 'My first timelet'
      page.should have_field 'name', with: 'My second timelet'
    end
  end

end
