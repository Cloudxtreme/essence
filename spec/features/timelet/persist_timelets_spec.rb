require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'storing timelets in localStorage' do
    create_timelet 'My first timelet', 15
    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_field 'name', with: 'My first timelet'
      page.should have_field 'name', with: 'My second timelet'
    end

    visit '/timelet'

    within 'section.timelets' do
      page.should have_field 'name', with: 'My first timelet'
      page.should have_field 'name', with: 'My second timelet'
    end
  end

  scenario 'loading timelets from localStorage' do
    create_timelet 'My first timelet', 15
    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_field 'name', with: 'My first timelet'
      page.should have_field 'name', with: 'My second timelet'
    end

    within 'section.timelets' do
      load_timelet 'My first timelet'
    end
    first_timelet_path = current_path

    within 'section.timelets' do
      page.should have_field 'name', with: 'My first timelet'
      page.should have_field 'name', with: 'My second timelet'
    end

    within 'section.timelets' do
      load_timelet 'My second timelet'
    end
    second_timelet_path = current_path

    visit first_timelet_path

    within 'section.clock' do
      page.should have_content '15'
    end

    within 'section.timelets' do
      page.should have_field 'name', with: 'My first timelet'
      page.should have_field 'name', with: 'My second timelet'
    end

    visit second_timelet_path

    within 'section.clock' do
      page.should have_content '30'
    end

    within 'section.timelets' do
      page.should have_field 'name', with: 'My first timelet'
      page.should have_field 'name', with: 'My second timelet'
    end
  end

end
