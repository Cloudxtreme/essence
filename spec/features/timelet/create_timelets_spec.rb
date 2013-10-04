require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'creating two timelets with the clock' do
    create_clock_timelet 'My first timelet', 15

    within 'section.timelets' do
      page.should have_content 'My first timelet'
    end

    find('.add').click

    create_clock_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'
    end
  end

end
