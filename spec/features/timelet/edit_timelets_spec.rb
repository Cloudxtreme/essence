require 'spec_helper'

feature 'Editing timelets' do

  background do
    visit '/timelet'
  end

  scenario 'edit a newly created timelet' do
    create_timelet 'My first timelet', 33

    within 'section.timelets' do
      page.should have_content 'My first timelet'

      find('span.name', text: 'My first timelet').click
      page.should have_content '33'

      fill_in_editable '.duration span.editable', '67'
      fill_in_editable '.name.editable', 'My edited timelet'
      find('.details label').click

      find('.save').click

      page.should have_no_content 'My first timelet'
      page.should have_content 'My edited timelet'
    end
  end
end
