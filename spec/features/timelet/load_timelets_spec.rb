require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'loading an existing timelet' do
    create_clock_timelet 'My first timelet', 15
    find('.add').click
    create_clock_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_content 'My first timelet (15s)'
      page.should have_content 'My second timelet (30s)'
    end

    within 'section.clock' do
      page.should have_content '30'
    end

    within 'section.timelets' do
      first('.load').click
    end

    within 'section.clock' do
      page.should have_content '15'
    end
  end

end
