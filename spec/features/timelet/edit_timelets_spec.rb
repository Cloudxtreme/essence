require 'spec_helper'

feature 'Editing timelets' do

  background do
    visit '/timelet'
  end

  scenario 'edit a timelet created in the clock' do
    create_clock_timelet 'My first timelet', 33

    within 'section.clock' do
      page.should have_content 'My first timelet'
      page.should have_content '33'
    end

    within 'section.timelets' do
      page.should have_content 'My first timelet'
      page.should have_css 'li.loaded'
    end

    fill_in_editable 'span.time', '67'
    fill_in_editable 'span.name', 'My edited timelet'

    within 'section.clock' do
      find('.title').click
      find('.save').click
    end

    within 'section.clock' do
      page.should have_content '67'
    end

    within 'section.timelets' do
      page.should have_no_content 'My first timelet'
      page.should have_content 'My edited timelet'
    end
  end

  scenario 'edit a timelet loaded from the list of timelets' do
    TODO
  end

  scenario 'edit a saved timelet from the list of timelets' do
    TODO
  end
end
