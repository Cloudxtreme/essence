require 'spec_helper'

feature 'Editing timelets' do

  background do
    visit '/timelet'
  end

  scenario 'edit a saved timelet' do
    create_clock_timelet 'My first timelet', 33

    within 'section.clock' do
      page.should have_content '33'
    end

    within 'section.timelets' do
      page.should have_content 'My first timelet (33s)'
    end

    fill_in_editable 'span.time', '67'
    fill_in_editable 'span.name', 'My edited timelet'
    find('.title').click
    find('.save').click

    within 'section.clock' do
      page.should have_content '67'
    end

    within 'section.timelets' do
      page.should have_no_content 'My first timelet (33s)'
      page.should have_content 'My edited timelet (67s)'
    end
  end
end
