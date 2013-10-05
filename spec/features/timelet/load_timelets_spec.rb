require 'spec_helper'

feature 'Creating timelets' do

  background do
    visit '/timelet'
  end

  scenario 'loading an existing timelet' do
    create_timelet 'My first timelet', 15
    create_timelet 'My second timelet', 30

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_content 'My second timelet'

      find('h3', text: 'My second timelet').find('.load').click
    end

    within 'section.clock' do
      page.should have_content '30'
    end

    within 'section.timelets' do
      find('h3', text: 'My first timelet').find('.load').click
    end

    within 'section.clock' do
      page.should have_content '15'
    end
  end

end
