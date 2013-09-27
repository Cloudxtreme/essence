require 'spec_helper'

feature 'Visiting timelet module' do

  background do
    visit '/timelet'
  end

  scenario 'Viewing the timelets index' do
    page.should have_css 'section.timelets'
  end
end
